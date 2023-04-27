import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

/// A TextEditingController with overrides buildTextSpan for building
/// marked TextSpans with tap recognizer
class ColoredTextEditingController extends TextEditingController {
  /// List which contains Mistake objects spans are built from
  List<Mistake> _mistakes = [];

  final double _backGroundOpacity =
  0.2; // background opacity for mistake TextSpan

  final double _mistakeLineThickness =
  1.5; // mistake TextSpan underline thickness

  /// A method sets new list of Mistake and triggers buildTextSpan
  void setMistakes(List<Mistake> list) {
    _mistakes = list;
    notifyListeners();
  }

  /// builds TextSpan from Mistake list
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    int currentOffset = 0; // enter index
    final List<TextSpan> spans = []; // List of TextSpan
    final int textLength = text.length; // Length of text to be built

    /// Iterates _mistakes and adds TextSpans from Mistake offset and length
    for (final Mistake mistake in _mistakes) {
      /// Breaks the loop if iterated Mistake offset is bigger than text length.
      if (mistake.offset > textLength ||
          mistake.offset + mistake.length > textLength) {
        break;
      }

      /// TextSpan before mistake
      spans.add(
        TextSpan(
          text: text.substring(
            currentOffset,
            mistake.offset,
          ),
          style: style,
        ),
      );

      /// Setting color of the mistake by its type
      final Color mistakeColor = _getMistakeColor(mistake.type);

      /// The mistake TextSpan
      spans.add(
        TextSpan(
          text: text.substring(mistake.offset, mistake.offset + mistake.length),
          mouseCursor: MaterialStateMouseCursor.clickable,
          recognizer: TapGestureRecognizer()
            ..onTapDown = _callOverlay, // calls overlay with mistakes details
          style: style?.copyWith(
            backgroundColor: mistakeColor.withOpacity(_backGroundOpacity),
            decoration: TextDecoration.underline,
            decorationColor: mistakeColor,
            decorationThickness: _mistakeLineThickness,
          ),
        ),
      );

      /// Changing enter index position for the next iteration
      currentOffset = mistake.offset + mistake.length;
    }

    /// TextSpan after mistake
    spans.add(
      TextSpan(
        text: text.substring(currentOffset),
        style: style,
      ),
    );

    /// Returns TextSpan
    return TextSpan(children: spans);
  }

  void _callOverlay(TapDownDetails details) {
    log(details.globalPosition.toString());
  }

  /// Returns color for mistake TextSpan style
  Color _getMistakeColor(String type) {
    switch (type) {
      case 'misspelling':
        return Colors.red;
      case 'style':
        return Colors.blue;
      case 'uncategorized':
        return Colors.amber;
      default:
        return Colors.green;
    }
  }
}
