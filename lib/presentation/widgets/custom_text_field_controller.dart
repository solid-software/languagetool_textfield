import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

/// Custom controller for an editable text field, that supports
/// mistakes highlighting.
class CustomTextFieldController extends TextEditingController {
  /// List of mistakes in text.
  final List<Mistake> mistakes;

  /// Creates a controller for an editable text field.
  CustomTextFieldController({
    String? text,
    this.mistakes = const [],
  }) : super(text: text);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> children = [];
    const underlineThickness = 2.0;
    const backgroundOpacity = 0.2;

    if (mistakes.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    for (int i = 0; i < mistakes.length; i++) {
      final mistake = mistakes[i];
      final previousMistakePosition =
          i > 0 ? mistakes[i - 1].offset + mistakes[i - 1].length : 0;
      final mistakeStart = mistake.offset;
      final mistakeEnd = mistakeStart + mistake.length;

      children.add(
        TextSpan(text: text.substring(previousMistakePosition, mistakeStart)),
      );

      children.add(
        TextSpan(
          text: text.substring(mistakeStart, mistakeEnd),
          style: TextStyle(
            decoration: TextDecoration.underline,
            decorationColor: Colors.red,
            decorationThickness: underlineThickness,
            backgroundColor: Colors.red.withOpacity(backgroundOpacity),
          ),
        ),
      );

      if (mistake == mistakes.last) {
        children.add(
          TextSpan(
            text: text.substring(
              mistakeEnd,
            ),
          ),
        );
      }
    }

    return TextSpan(children: children, style: style);
  }
}
