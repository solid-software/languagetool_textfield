import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_textfield/src/client/language_tool_client.dart';
import 'package:languagetool_textfield/src/core/enums/delay_type.dart';
import 'package:languagetool_textfield/src/core/enums/mistake_type.dart';
import 'package:languagetool_textfield/src/domain/highlight_style.dart';
import 'package:languagetool_textfield/src/domain/language_check_service.dart';
import 'package:languagetool_textfield/src/domain/mistake.dart';
import 'package:languagetool_textfield/src/implementations/debounce_lang_tool_service.dart';
import 'package:languagetool_textfield/src/implementations/lang_tool_service.dart';
import 'package:languagetool_textfield/src/implementations/throttling_lang_tool_service.dart';
import 'package:languagetool_textfield/src/utils/closed_range.dart';
import 'package:languagetool_textfield/src/utils/keep_latest_response_service.dart';
import 'package:languagetool_textfield/src/utils/mistake_popup.dart';

/// A TextEditingController with overrides buildTextSpan for building
/// marked TextSpans with tap recognizer
class LanguageToolController extends TextEditingController {
  bool _isEnabled;

  /// Color scheme to highlight mistakes
  final HighlightStyle highlightStyle;

  /// Represents the type of delay for language checking.
  ///
  /// [DelayType.debouncing] - Calls a function when a user hasn't carried out
  /// the event in a specific amount of time.
  ///
  /// [DelayType.throttling] - Calls a function at intervals of a specified
  /// amount of time while the user is carrying out the event.
  final DelayType delayType;

  /// Represents the duration of the delay for language checking.
  ///
  /// If the delay is [Duration.zero], no delaying is applied.
  final Duration delay;

  /// Create an instance of [LanguageToolClient] instance
  final _languageToolClient = LanguageToolClient();

  /// Create an instance of [KeepLatestResponseService]
  /// to handle asynchronous operations
  final _latestResponseService = KeepLatestResponseService();

  /// List of that is used to dispose recognizers after mistakes rebuilt
  final List<TapGestureRecognizer> _recognizers = [];

  /// Language tool API index
  LanguageCheckService? _languageCheckService;

  /// Reference to the focus of the LanguageTool TextField
  FocusNode? focusNode;

  /// List which contains Mistake objects spans are built from
  List<Mistake> _mistakes = [];

  /// Reference to the popup widget
  MistakePopup? popupWidget;

  /// Represents the scroll offset value of the LanguageTool TextField.
  double? scrollOffset;

  Object? _fetchError;

  /// The language used for spellchecking in the text field.
  ///
  /// A language code like en-US, de-DE, fr, or auto to guess
  /// the language automatically.
  String get language => _languageToolClient.language;

  set language(String language) {
    _languageToolClient.language = language;
  }

  /// Indicates whether spell checking is enabled
  bool get isEnabled => _isEnabled;

  set isEnabled(bool value) {
    _isEnabled = value;

    if (_isEnabled) {
      _handleTextChange(text, force: true);
    } else {
      notifyListeners();
    }
  }

  /// An error that may have occurred during the API fetch.
  Object? get fetchError => _fetchError;

  @override
  set value(TextEditingValue newValue) {
    if (_isEnabled) {
      _handleTextChange(newValue.text);
    }

    super.value = newValue;
  }

  /// Controller constructor
  LanguageToolController({
    bool isEnabled = true,
    this.highlightStyle = const HighlightStyle(),
    this.delay = Duration.zero,
    this.delayType = DelayType.debouncing,
  }) : _isEnabled = isEnabled {
    _languageCheckService = _getLanguageCheckService();
  }

  LanguageCheckService _getLanguageCheckService() {
    final languageToolService = LangToolService(_languageToolClient);

    if (delay == Duration.zero) return languageToolService;

    switch (delayType) {
      case DelayType.debouncing:
        return DebounceLangToolService(languageToolService, delay);
      case DelayType.throttling:
        return ThrottlingLangToolService(languageToolService, delay);
    }
  }

  /// Close the popup widget
  void _closePopup() => popupWidget?.popupRenderer.dismiss();

  /// Generates TextSpan from Mistake list
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    required bool withComposing,
    TextStyle? style,
  }) {
    if (!_isEnabled) {
      return super.buildTextSpan(
        context: context,
        withComposing: withComposing,
        style: style,
      );
    }

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
    _languageCheckService?.dispose();
    super.dispose();
  }

  /// Replaces mistake with given replacement
  void replaceMistake(Mistake mistake, String replacement) {
    if (!_isEnabled) {
      throw Exception('LanguageToolController is not enabled');
    }

    final mistakes = List<Mistake>.from(_mistakes);
    mistakes.remove(mistake);
    _mistakes = mistakes;
    text = text.replaceRange(mistake.offset, mistake.endOffset, replacement);
    focusNode?.requestFocus();
    Future.microtask.call(() {
      final newOffset = mistake.offset + replacement.length;
      selection = TextSelection.fromPosition(TextPosition(offset: newOffset));
    });
  }

  /// Clear mistakes list when text mas modified and get a new list of mistakes
  /// via API
  Future<void> _handleTextChange(String newText, {bool force = false}) async {
    ///set value triggers each time, even when cursor changes its location
    ///so this check avoid cleaning Mistake list when text wasn't really changed
    if (!force && (newText == text || newText.isEmpty)) return;

    final filteredMistakes = _filterMistakesOnChanged(newText);
    _mistakes = filteredMistakes.toList();

    // If we have a text change and we have a popup on hold
    // it will close the popup
    _closePopup();

    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

    final mistakesWrapper = await _latestResponseService.processLatestOperation(
      () => _languageCheckService?.findMistakes(newText) ?? Future(() => null),
    );
    if (mistakesWrapper == null || !mistakesWrapper.hasResult) return;

    final mistakes = mistakesWrapper.result();
    _fetchError = mistakesWrapper.error;

    _mistakes = mistakes;
    notifyListeners();
  }

  /// Generator function to create TextSpan instances
  Iterable<TextSpan> _generateSpans(
    BuildContext context, {
    TextStyle? style,
  }) sync* {
    int currentOffset = 0; // enter index

    _mistakes.sort((a, b) => a.offset.compareTo(b.offset));

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
      final onTap = TapGestureRecognizer()
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
      _recognizers.add(onTap);

      /// Mistake highlighted TextSpan
      yield TextSpan(
        children: [
          TextSpan(
            text: text.substring(
              mistake.offset,
              min(mistake.endOffset, text.length),
            ),
            mouseCursor: WidgetStateMouseCursor.textable,
            style: style?.copyWith(
              backgroundColor: mistakeColor.withValues(
                alpha: highlightStyle.backgroundOpacity,
              ),
              decoration: highlightStyle.decoration,
              decorationColor: mistakeColor,
              decorationThickness: highlightStyle.mistakeLineThickness,
            ),
            recognizer: onTap,
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
  Iterable<Mistake> _filterMistakesOnChanged(String newText) sync* {
    final isSelectionRangeEmpty = selection.end == selection.start;
    final lengthDiscrepancy = newText.length - text.length;

    for (final mistake in _mistakes) {
      Mistake? newMistake;

      newMistake = isSelectionRangeEmpty
          ? _adjustMistakeOffsetWithCaretCursor(
              mistake: mistake,
              lengthDiscrepancy: lengthDiscrepancy,
            )
          : _adjustMistakeOffsetWithSelectionRange(
              mistake: mistake,
              lengthDiscrepancy: lengthDiscrepancy,
            );

      if (newMistake != null) yield newMistake;
    }
  }

  /// Adjusts the mistake offset when the selection is a caret cursor.
  Mistake? _adjustMistakeOffsetWithCaretCursor({
    required Mistake mistake,
    required int lengthDiscrepancy,
  }) {
    final mistakeRange = ClosedRange(mistake.offset, mistake.endOffset);
    final caretLocation = selection.base.offset;

    // Don't highlight mistakes on changed text
    // until we get an update from the API.
    final isCaretOnMistake = mistakeRange.contains(caretLocation);
    if (isCaretOnMistake) return null;

    final shouldAdjustOffset = mistakeRange.isBeforeOrAt(caretLocation);
    if (!shouldAdjustOffset) return mistake;

    final newOffset = mistake.offset + lengthDiscrepancy;

    return mistake.copyWith(offset: newOffset);
  }

  /// Adjusts the mistake offset when the selection is a range.
  Mistake? _adjustMistakeOffsetWithSelectionRange({
    required Mistake mistake,
    required int lengthDiscrepancy,
  }) {
    final selectionRange = ClosedRange(selection.start, selection.end);
    final mistakeRange = ClosedRange(mistake.offset, mistake.endOffset);

    final hasSelectedTextChanged = selectionRange.overlapsWith(mistakeRange);
    if (hasSelectedTextChanged) return null;

    final shouldAdjustOffset = selectionRange.isAfterOrAt(mistake.offset);
    if (!shouldAdjustOffset) return mistake;

    final newOffset = mistake.offset + lengthDiscrepancy;

    return mistake.copyWith(offset: newOffset);
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
    Future.microtask(() => selection = TextSelection.collapsed(offset: offset));

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
    final textFieldWidth = textFieldRenderBox?.size.width ?? 0;
    final scrollOffset = this.scrollOffset ?? 0;

    double maxWidth = double.infinity;
    if (scrollOffset == 0) maxWidth = textFieldWidth;

    textPainter.layout(minWidth: textFieldWidth, maxWidth: maxWidth);

    final adjustedOffset =
        Offset(localOffset.dx + scrollOffset, localOffset.dy);

    return textPainter.getPositionForOffset(adjustedOffset).offset;
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
