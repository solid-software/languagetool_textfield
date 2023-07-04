import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_textfield/core/enums/mistake_type.dart';
import 'package:languagetool_textfield/domain/highlight_style.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/implementations/keep_latest_response_service.dart';
import 'package:languagetool_textfield/utils/closed_range.dart';
import 'package:languagetool_textfield/utils/mistake_popup.dart';

/// A TextEditingController with overrides buildTextSpan for building
/// marked TextSpans with tap recognizer
class ColoredTextEditingController extends TextEditingController {
  /// Color scheme to highlight mistakes
  final HighlightStyle highlightStyle;

  /// Language tool API index
  final LanguageCheckService languageCheckService;

  /// Create an instance of [KeepLatestResponseService]
  ///  to handle asynchronous operations
  final latestResponseService = KeepLatestResponseService();

  /// List which contains Mistake objects spans are built from
  List<Mistake> _mistakes = [];

  /// List of that is used to dispose recognizers after mistakes rebuilt
  final List<TapGestureRecognizer> _recognizers = [];

  /// Reference to the popup widget
  MistakePopup? popupWidget;

  /// Reference to the focus of the LanguageTool TextField
  FocusNode? focusNode;

  Object? _fetchError;

  /// An error that may have occurred during the API fetch.
  Object? get fetchError => _fetchError;

  @override
  set value(TextEditingValue newValue) {
    _handleTextChange(newValue.text);
    super.value = newValue;
  }

  /// Controller constructor
  ColoredTextEditingController({
    required this.languageCheckService,
    this.highlightStyle = const HighlightStyle(),
  });

  /// Close the popup widget
  void _closePopup() => popupWidget?.popupRenderer.dismiss();

  /// Generates TextSpan from Mistake list
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final formattedTextSpans = _generateSpans(
      context,
      style: style,
    );

    return TextSpan(
      children: formattedTextSpans.toList(),
    );
  }

  @override
  void dispose() {
    languageCheckService.dispose();
    super.dispose();
  }

  /// Replaces mistake with given replacement
  void replaceMistake(Mistake mistake, String replacement) {
    final mistakes = List<Mistake>.from(_mistakes);
    mistakes.remove(mistake);
    _mistakes = mistakes;
    text = text.replaceRange(mistake.offset, mistake.endOffset, replacement);
    _mistakes.remove(mistake);
    focusNode?.requestFocus();
    Future.microtask.call(() {
      final newOffset = mistake.offset + replacement.length;
      selection = TextSelection.fromPosition(TextPosition(offset: newOffset));
    });
  }

  /// Clear mistakes list when text mas modified and get a new list of mistakes
  /// via API
  Future<void> _handleTextChange(String newText) async {
    ///set value triggers each time, even when cursor changes its location
    ///so this check avoid cleaning Mistake list when text wasn't really changed
    if (newText == text) return;

    final filteredMistakes = _filterMistakesOnChanged(newText);
    _mistakes = filteredMistakes;

    // If we have a text change and we have a popup on hold
    // it will close the popup
    _closePopup();

    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

    final mistakesWrapper = await latestResponseService.processLatestOperation(
      () => languageCheckService.findMistakes(newText),
    );
    final mistakes = mistakesWrapper?.result();
    _fetchError = mistakesWrapper?.error;

    if (mistakes == null) return;

    _mistakes = mistakes;
    notifyListeners();
  }

  /// Generator function to create TextSpan instances
  Iterable<TextSpan> _generateSpans(
    BuildContext context, {
    TextStyle? style,
  }) sync* {
    int currentOffset = 0; // enter index

    for (final Mistake mistake in _mistakes) {
      final mistakeEndOffset = min(mistake.endOffset, text.length);
      if (mistake.offset > mistakeEndOffset) continue;

      /// TextSpan before mistake
      yield TextSpan(
        text: text.substring(
          currentOffset,
          min(mistake.offset, text.length),
        ),
        style: style,
      );

      /// Get a highlight color
      final Color mistakeColor = _getMistakeColor(mistake.type);

      /// Create a gesture recognizer for mistake
      final _onTap = TapGestureRecognizer()
        ..onTapDown = (details) {
          popupWidget?.show(
            context,
            mistake: mistake,
            popupPosition: details.globalPosition,
            controller: this,
            onClose: (details) => _setCursorOnMistake(
              context,
              globalPosition: details.globalPosition,
              style: style,
            ),
          );

          // Set the cursor position on the mistake
          _setCursorOnMistake(
            context,
            globalPosition: details.globalPosition,
            style: style,
          );
        };

      /// Adding recognizer to the list for future disposing
      _recognizers.add(_onTap);

      /// Mistake highlighted TextSpan
      yield TextSpan(
        children: [
          TextSpan(
            text: text.substring(
              mistake.offset,
              min(mistake.endOffset, text.length),
            ),
            mouseCursor: MaterialStateMouseCursor.textable,
            style: style?.copyWith(
              backgroundColor: mistakeColor.withOpacity(
                highlightStyle.backgroundOpacity,
              ),
              decoration: highlightStyle.decoration,
              decorationColor: mistakeColor,
              decorationThickness: highlightStyle.mistakeLineThickness,
            ),
            recognizer: _onTap,
          ),
        ],
      );

      currentOffset = min(mistake.endOffset, text.length);
    }

    final textAfterMistake = text.substring(currentOffset);

    /// TextSpan after mistake
    yield TextSpan(
      text: textAfterMistake,
      style: style,
    );
  }

  /// Filters the list of mistakes based on the changes
  /// in the text when it is changed.
  List<Mistake> _filterMistakesOnChanged(String newText) {
    final newMistakes = <Mistake>[];
    final selectionRange = ClosedRange(selection.start, selection.end);

    for (final mistake in _mistakes) {
      final mistakeRange = ClosedRange(mistake.offset, mistake.endOffset);

      if (selectionRange.containsRange(mistakeRange)) continue;

      final isLengthIncreased = newText.length > text.length;
      final baseOffset = selection.base.offset;

      if (isLengthIncreased && mistakeRange.contains(baseOffset)) {
        continue;
      }

      if (!isLengthIncreased &&
          (mistakeRange.contains(baseOffset) ||
              mistakeRange.overlapsWith(selectionRange))) continue;

      final isTextLengthIncreasedAndBaseBeforeMistake =
          isLengthIncreased && mistakeRange.isBefore(baseOffset);
      final isTextLengthNotIncreasedAndBaseBeforeOrAtMistake =
          !isLengthIncreased && mistakeRange.isBeforeOrAt(baseOffset);

      final lengthDiscrepancy = newText.length - text.length;
      final newOffset = mistake.offset + lengthDiscrepancy;

      isTextLengthIncreasedAndBaseBeforeMistake ||
              isTextLengthNotIncreasedAndBaseBeforeOrAtMistake
          ? newMistakes.add(mistake.copyWith(offset: newOffset))
          : newMistakes.add(mistake);
    }

    return newMistakes;
  }

  /// Returns color for mistake TextSpan style
  Color _getMistakeColor(MistakeType type) {
    switch (type) {
      case MistakeType.misspelling:
        return highlightStyle.misspellingMistakeColor;
      case MistakeType.typographical:
        return highlightStyle.typographicalMistakeColor;
      case MistakeType.grammar:
        return highlightStyle.grammarMistakeColor;
      case MistakeType.uncategorized:
        return highlightStyle.uncategorizedMistakeColor;
      case MistakeType.nonConformance:
        return highlightStyle.nonConformanceMistakeColor;
      case MistakeType.style:
        return highlightStyle.styleMistakeColor;
      case MistakeType.other:
        return highlightStyle.otherMistakeColor;
    }
  }

  /// Sets the cursor position on a mistake within the text field based
  /// on the provided [globalPosition].
  ///
  /// The [context] is used to find the render object associated
  /// with the text field.
  /// The [style] is an optional parameter to customize the text style.
  void _setCursorOnMistake(
    BuildContext context, {
    required Offset globalPosition,
    TextStyle? style,
  }) {
    final offset = _getValidTextOffset(
      context,
      globalPosition: globalPosition,
      style: style,
    );

    if (offset == null) return;

    focusNode?.requestFocus();
    Future.microtask.call(
      () => selection = TextSelection.collapsed(offset: offset),
    );

    // Find the mistake within the text that corresponds to the offset
    final mistake = _mistakes.firstWhereOrNull(
      (e) => e.offset <= offset && offset < e.endOffset,
    );

    if (mistake == null) return;

    _closePopup();

    // Show a popup widget with the mistake details
    popupWidget?.show(
      context,
      mistake: mistake,
      popupPosition: globalPosition,
      controller: this,
      onClose: (details) => _setCursorOnMistake(
        context,
        globalPosition: details.globalPosition,
        style: style,
      ),
    );
  }

  /// Returns a valid text offset based on the provided [globalPosition]
  /// within the text field.
  ///
  /// The [context] is used to find the render object associated
  /// with the text field.
  /// The [style] is an optional parameter to customize the text style.
  /// Returns the offset within the text if it falls within the vertical bounds
  /// of the text field, otherwise returns null.
  int? _getValidTextOffset(
    BuildContext context, {
    required Offset globalPosition,
    TextStyle? style,
  }) {
    final textFieldRenderBox = context.findRenderObject() as RenderBox?;
    final localOffset = textFieldRenderBox?.globalToLocal(globalPosition);

    if (localOffset == null) return null;

    final textBoxHeight = textFieldRenderBox?.size.height ?? 0;

    // If local offset is outside the vertical bounds of the text field,
    // return null
    final isOffsetOutsideTextBox =
        localOffset.dy < 0 || textBoxHeight < localOffset.dy;
    if (isOffsetOutsideTextBox) return null;

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    return textPainter.getPositionForOffset(localOffset).offset;
  }

  /// The `onClosePopup` function is a callback method typically used
  /// when a popup or overlay is closed. Its purpose is to ensure a smooth user
  /// experience by handling the behavior when the popup is dismissed
  void onClosePopup() {
    final offset = selection.base.offset;
    focusNode?.requestFocus();

    // Delay the execution of the following code until the next microtask
    Future.microtask(
      () => selection = TextSelection.collapsed(offset: offset),
    );
  }
}
