import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:languagetool_textfield/core/enums/mistake_type.dart';
import 'package:languagetool_textfield/domain/highlight_style.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/presentation/suggestions_popup.dart';

/// A TextEditingController with overrides buildTextSpan for building
/// marked TextSpans with tap recognizer
class ColoredTextEditingController extends TextEditingController {
  /// An [OverlayEntry] for the [Overlay] class.
  /// This entry represents the floating popup
  /// that appears on a mistake.
  OverlayEntry? overlayEntry;

  /// Represents the maximum numbers of suggestions.
  final int suggestionsLimit;

  /// Color scheme to highlight mistakes
  final HighlightStyle highlightStyle;

  /// Language tool API index
  final LanguageCheckService languageCheckService;

  /// List which contains Mistake objects spans are built from
  List<Mistake> _mistakes = [];

  @override
  set value(TextEditingValue newValue) {
    _handleTextChange(newValue.text);
    super.value = newValue;
  }

  /// Controller constructor
  ColoredTextEditingController({
    required this.languageCheckService,
    this.highlightStyle = const HighlightStyle(),
    this.suggestionsLimit = 4,
  });

  /// Clear mistakes list when text mas modified and get a new list of mistakes
  /// via API
  Future<void> _handleTextChange(String newText) async {
    ///set value triggers each time, even when cursor changes its location
    ///so this check avoid cleaning Mistake list when text wasn't really changed
    if (newText == text) return;
    _mistakes.clear();
    final mistakes = await languageCheckService.findMistakes(newText);
    if (mistakes.isNotEmpty) {
      _mistakes = mistakes;
      notifyListeners();
    }
  }

  /// Generates TextSpan from Mistake list
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final formattedTextSpans = _generateSpans(
      context: context,
      style: style,
    );

    return TextSpan(
      children: formattedTextSpans.toList(),
    );
  }

  /// Generator function to create TextSpan instances
  Iterable<TextSpan> _generateSpans({
    required BuildContext context,
    TextStyle? style,
  }) sync* {
    int currentOffset = 0; // enter index

    for (final Mistake mistake in _mistakes) {
      /// TextSpan before mistake
      yield TextSpan(
        text: text.substring(
          currentOffset,
          mistake.offset,
        ),
        style: style,
      );

      /// Get a highlight color
      final Color mistakeColor = _getMistakeColor(mistake.type);

      /// Only getting the first 4 recommended suggestions.
      final List<String> replacements =
          mistake.replacements.length <= suggestionsLimit
              ? mistake.replacements
              : mistake.replacements.sublist(0, suggestionsLimit);

      /// Parsing the mistake enum types to string type
      final String mistakeName =
          mistake.type.name[0].toUpperCase() + mistake.type.name.substring(1);

      /// Mistake highlighted TextSpan
      yield TextSpan(
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTapDown = (TapDownDetails pressDetails) {
                /// getting the position of the user's finger
                final position = pressDetails.globalPosition;

                /// removing the overlay that is already present
                _removeHighlightOverlay();

                overlayEntry = OverlayEntry(
                  builder: (BuildContext context) {
                    return SuggestionsPopup(
                      mistakeName: mistakeName,
                      mistakeMessage: mistake.message,
                      mistakeColor: mistakeColor,
                      replacements: replacements,
                      onTapCallback: (newValue) {
                        text = text.replaceRange(
                          mistake.offset,
                          mistake.offset + mistake.length,
                          newValue,
                        );
                        _removeHighlightOverlay();
                      },
                      dx: position.dx,
                      dy: position.dy + 10,
                    );
                  },
                );

                Overlay.of(context).insert(overlayEntry!);
              },
            text:
                text.substring(mistake.offset, mistake.offset + mistake.length),
            mouseCursor: MaterialStateMouseCursor.clickable,
            style: style?.copyWith(
              backgroundColor: mistakeColor.withOpacity(
                highlightStyle.backgroundOpacity,
              ),
              decoration: highlightStyle.decoration,
              decorationColor: mistakeColor,
              decorationThickness: highlightStyle.mistakeLineThickness,
            ),
          ),
        ],
      );

      currentOffset = mistake.offset + mistake.length;
    }

    /// TextSpan after mistake
    yield TextSpan(
      text: text.substring(currentOffset),
      style: style,
    );
  }

  void _removeHighlightOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
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
