library languagetool_textfield;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:language_tool/language_tool.dart';
import 'package:throttling/throttling.dart';

/// Test TextEditingController
class SpellTextEditingController extends TextEditingController {
  final LanguageTool _languageTool = LanguageTool();
  final Debouncing _debounce = Debouncing(duration: const Duration(seconds: 3));
  String _textTemp = '';
  List<WritingMistake> _mistakes = [];

  /// Creates a spell check controller for an editable text field.
  ///
  /// Treats a null [text] argument as if it were the empty string.
  ///
  /// The [duration] property is set to 3 seconds by default.
  SpellTextEditingController({super.text, Duration? duration}) {
    if (duration != null) _debounce.duration = duration;
    if (text.isNotEmpty) notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
    // Notify listeners to call buildTextSpan when need to show spell check
    if (_textTemp != text) {
      _textTemp = text;
      _mistakes = [];
      _debounce.debounce(() async {
        try {
          _mistakes = await _languageTool.check(_textTemp);
          notifyListeners();
        } catch (_) {}
      });
    }
  }

  @override
  void dispose() {
    _debounce.close();
    super.dispose();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (_mistakes.isEmpty) {
      return TextSpan(text: text, style: style);
    }
    // Rebuild TextSpan based on mistakes
    final List<TextSpan> children = [];
    try {
      const TextStyle errorStyle = TextStyle(
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.wavy,
        decorationColor: Colors.red,
      );
      for (int i = 0; i < _mistakes.length; i++) {
        final String left = (i == 0)
            ? text.substring(0, _mistakes[i].offset)
            : text.substring(
                _mistakes[i - 1].offset + _mistakes[i - 1].length,
                _mistakes[i].offset,
              );
        if (left.isNotEmpty) children.add(TextSpan(text: left, style: style));
        final String mid = text.substring(
          _mistakes[i].offset,
          _mistakes[i].offset + _mistakes[i].length,
        );
        children.add(
          TextSpan(
            text: mid,
            style: style?.merge(errorStyle) ?? errorStyle,
            // TextSpan callback
            recognizer: TapGestureRecognizer()
              ..onTapUp = (TapUpDetails details) {
                showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        children: [
                          Text(_mistakes[i].issueType),
                          Text(_mistakes[i].issueDescription),
                          Text(_mistakes[i].message),
                          Text(_mistakes[i].shortMessage),
                          const Divider(),
                          ..._mistakes[i].replacements.map((m) => Text(m)),
                        ],
                      ),
                    );
                  },
                );
              },
          ),
        );
      }
      final String right =
          text.substring(_mistakes.last.offset + _mistakes.last.length);
      if (right.isNotEmpty) children.add(TextSpan(text: right, style: style));
    } catch (_) {
      return TextSpan(text: text, style: style);
    }

    return TextSpan(children: children, style: style);
  }
}
