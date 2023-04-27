import 'package:flutter/material.dart';
import 'package:languagetool_textfield/core/enums/mistake_type.dart';
import 'package:languagetool_textfield/domain/highlight_style.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

/// A TextEditingController with overrides buildTextSpan for building
/// marked TextSpans with tap recognizer
class ColoredTextEditingController extends TextEditingController {
  /// Color scheme to highlight mistakes
  final HighlightStyle highlightStyle;

  /// List which contains Mistake objects spans are built from
  List<Mistake> _mistakes = [];

  @override
  set value(TextEditingValue newValue) {
    _handleTextChange(newValue.text);
    super.value = newValue;
  }

  /// Controller constructor
  ColoredTextEditingController({
    this.highlightStyle = const HighlightStyle(),
  });

  /// Clear mistakes list when text mas modified
  void _handleTextChange(String newValue) {
    if (newValue.length != text.length) {
      _mistakes.clear();
    }
  }

  /// Generates TextSpan from Mistake list
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final Iterable<TextSpan> spanList = _generateSpans(
      style: style,
    );

    return TextSpan(
      children: spanList.toList(),
    );
  }

  /// Generator function to create TextSpan instances
  Iterable<TextSpan> _generateSpans({
    // required int textLength,
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

      /// Mistake highlighted TextSpan
      yield TextSpan(
        text: text.substring(mistake.offset, mistake.offset + mistake.length),
        mouseCursor: MaterialStateMouseCursor.clickable,
        style: style?.copyWith(
          backgroundColor: mistakeColor.withOpacity(
            highlightStyle.backgroundOpacity,
          ),
          decoration: TextDecoration.underline,
          decorationColor: mistakeColor,
          decorationThickness: highlightStyle.mistakeLineThickness,
        ),
      );

      currentOffset = mistake.offset + mistake.length;
    }

    /// TextSpan after mistake
    yield TextSpan(
      text: text.substring(currentOffset),
      style: style,
    );
  }

  /// A method sets new list of Mistake and triggers buildTextSpan
  void highlightMistakes(List<Mistake> list) {
    _mistakes = list;
    notifyListeners();
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
