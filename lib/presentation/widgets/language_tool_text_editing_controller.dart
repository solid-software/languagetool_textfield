import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

/// A custom controller for an editable text field, that supports
/// mistakes highlighting.
class LanguageToolTextEditingController extends TextEditingController {
  /// A list of mistakes in the text.
  final List<Mistake> mistakes;

  /// Creates a controller for an editable text field.
  LanguageToolTextEditingController({
    String? text,
    this.mistakes = const [],
  }) : super(text: text);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final children = <TextSpan>[];
    const underlineThickness = 2.0;
    const backgroundOpacity = 0.2;

    if (mistakes.isEmpty) {
      return TextSpan(text: text, style: style);
    }

    final lastMistakeIndex = mistakes.length - 1;

    for (int i = 0; i < mistakes.length; i++) {
      final mistake = mistakes[i];
      int previousMistakePosition = 0;
      if (i > 0) {
        final previousMistake = mistakes[i - 1];
        previousMistakePosition =
            previousMistake.offset + previousMistake.length;
      }
      final mistakeStart = mistake.offset;
      final mistakeEnd = mistakeStart + mistake.length;

      if (mistakeEnd > text.length) {
        children.add(
          TextSpan(
            text: text.substring(previousMistakePosition),
          ),
        );
        break;
      }

      children.add(
        TextSpan(text: text.substring(previousMistakePosition, mistakeStart)),
      );

      final textStyle = style ?? const TextStyle();
      children.add(
        TextSpan(
          text: text.substring(mistakeStart, mistakeEnd),
          style: textStyle.copyWith(
            decoration: TextDecoration.underline,
            decorationColor: Colors.red,
            decorationThickness: underlineThickness,
            backgroundColor: Colors.red.withOpacity(backgroundOpacity),
          ),
        ),
      );

      if (i == lastMistakeIndex) {
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
