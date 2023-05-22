import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_textfield/core/enums/mistake_type.dart';
import 'package:languagetool_textfield/domain/highlight_style.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/utils/language_tool_mistake_popup.dart';

/// A TextEditingController with overrides buildTextSpan for building
/// marked TextSpans with tap recognizer
class ColoredTextEditingController extends TextEditingController {
  /// Color scheme to highlight mistakes
  final HighlightStyle highlightStyle;

  /// Language tool API index
  final LanguageCheckService languageCheckService;

  /// List which contains Mistake objects spans are built from
  List<Mistake> _mistakes = [];
  final List<TapGestureRecognizer> _recognizers = [];

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

  /// Clear mistakes list when text mas modified and get a new list of mistakes
  /// via API
  Future<void> _handleTextChange(String newText) async {
    ///set value triggers each time, even when cursor changes its location
    ///so this check avoid cleaning Mistake list when text wasn't really changed
    if (newText.length == text.length) return;

    _mistakes.clear();
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();

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
      context,
      style: style,
    );

    return TextSpan(
      children: formattedTextSpans.toList(),
    );
  }

  /// Generator function to create TextSpan instances
  Iterable<TextSpan> _generateSpans(
    BuildContext context, {
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

      /// Create a gesture recognizer for mistake
      final _onTap = TapGestureRecognizer()
        ..onTapDown = (details) {
          LanguageToolMistakePopup(
            mistake: mistake,
            mistakeOffset: details.globalPosition,
            width: 220,
            height: 120,
          ).show(context);
        };

      // /// Adding recognizer to the list for future disposing
      _recognizers.add(_onTap);

      /// Mistake highlighted TextSpan
      yield TextSpan(
        children: [
          TextSpan(
            text: text.substring(
              mistake.offset,
              mistake.offset + mistake.length,
            ),
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

      currentOffset = mistake.offset + mistake.length;
    }

    /// TextSpan after mistake
    yield TextSpan(
      text: text.substring(currentOffset),
      style: style,
    );
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
