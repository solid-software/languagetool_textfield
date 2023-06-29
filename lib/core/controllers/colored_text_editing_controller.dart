import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_textfield/core/enums/mistake_type.dart';
import 'package:languagetool_textfield/domain/highlight_style.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/domain/typedefs.dart';
import 'package:languagetool_textfield/utils/debouncer.dart';

/// A TextEditingController with overrides buildTextSpan for building
/// marked TextSpans with tap recognizer
class ColoredTextEditingController extends TextEditingController {
  /// Color scheme to highlight mistakes
  final HighlightStyle highlightStyle;

  /// Language tool API index
  final LanguageCheckService languageCheckService;

  /// List which contains Mistake objects spans are built from
  List<Mistake> _mistakes = [];

  /// List of that is used to dispose recognizers after mistakes rebuilt
  final List<TapGestureRecognizer> _recognizers = [];

  /// Create a debouncer instance with a debounce duration of 1200 milliseconds
  final _debouncer = Debouncer(milliseconds: 1200);

  /// Callback that will be executed after mistake clicked
  ShowPopupCallback? showPopup;

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
    selection = TextSelection.fromPosition(
      TextPosition(offset: mistake.offset + replacement.length),
    );
  }

  /// Clear mistakes list when text mas modified and get a new list of mistakes
  /// via API
  void _handleTextChange(String newText) {
    ///set value triggers each time, even when cursor changes its location
    ///so this check avoid cleaning Mistake list when text wasn't really changed
    if (newText == text) return;

    final filteredMistakes = _filterMistakesOnChanged(newText);
    _mistakes = filteredMistakes;

    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

    // Run the specified code block using the debouncer instance
    _debouncer.run(() {
      // Find mistakes in the new text using the language check service
      languageCheckService.findMistakes(newText).then((value) {
        // Retrieve the result and error information from the MistakesWrapper
        final mistakesWrapper = value;
        final mistakes = mistakesWrapper?.result();
        _fetchError = mistakesWrapper?.error;

        // Update the mistakes list with the new mistakes
        // or fallback to filteredMistakes
        _mistakes = mistakes ?? filteredMistakes;

        notifyListeners();
      });
    });
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
          showPopup?.call(context, mistake, details.globalPosition, this);
        };

      /// Adding recognizer to the list for future disposing
      _recognizers.add(_onTap);

      /// Mistake highlighted TextSpan
      yield TextSpan(
        children: [
          TextSpan(
            text: text.substring(mistake.offset, mistakeEndOffset),
            mouseCursor: MaterialStateMouseCursor.clickable,
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

    /// TextSpan after mistake
    yield TextSpan(
      text: text.substring(currentOffset),
      style: style,
    );
  }

  /// Filters the list of mistakes based on the changes
  /// in the text when it is changed.
  List<Mistake> _filterMistakesOnChanged(String newText) {
    final newMistakes = <Mistake>[];

    // Iterate through the existing mistakes
    // and filter them based on the selection and text changes
    for (final mistake in _mistakes) {
      // Skip the mistake if the selection encompasses the entire mistake
      if (selection.start <= mistake.offset &&
          selection.end >= mistake.endOffset) {
        continue;
      }

      // Calculate the discrepancy in length between the new text
      // and the original text
      final lengthDiscrepancy = newText.length - text.length;

      // Calculate the new offset for the mistake based
      // on the length discrepancy
      final newOffset = mistake.offset + lengthDiscrepancy;

      // Handle cases where the new text is longer than the original text
      if (newText.length > text.length) {
        // Skip the mistake if the selection is within the mistake boundaries
        if (selection.base.offset > mistake.offset &&
            selection.base.offset < mistake.endOffset) {
          continue;
        } else if (selection.base.offset == mistake.offset ||
            selection.base.offset == mistake.endOffset) {
          continue;
        }

        if (selection.base.offset < mistake.offset) {
          newMistakes.add(
            Mistake(
              message: mistake.message,
              type: mistake.type,
              offset: newOffset,
              length: mistake.length,
              replacements: mistake.replacements,
            ),
          );
          continue;
        }
      }
      // Handle cases where the new text is shorter
      // than or equal to the original text
      else {
        // Skip the mistake if the selection is within the mistake boundaries
        if (selection.base.offset > mistake.offset &&
            selection.base.offset <= mistake.endOffset) {
          continue;
        } else if (selection.end > mistake.offset &&
            selection.end <= mistake.endOffset) {
          continue;
        } else if (selection.start > mistake.offset &&
            selection.start <= mistake.endOffset) {
          continue;
        }

        if (selection.base.offset <= mistake.offset) {
          newMistakes.add(
            Mistake(
              message: mistake.message,
              type: mistake.type,
              offset: newOffset,
              length: mistake.length,
              replacements: mistake.replacements,
            ),
          );
          continue;
        }
      }

      // If the mistake doesn't meet any of the skipping conditions,
      // add it to the new list
      newMistakes.add(mistake);
    }

    // Return the filtered list of mistakes
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
}
