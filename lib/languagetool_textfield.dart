library languagetool_textfield;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:language_tool/language_tool.dart';
import 'package:throttling/throttling.dart';

/// Test TextEdittingController
class SpellTextEdittingController extends TextEditingController {
  List<WritingMistake> mistakes = [];

  SpellTextEdittingController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (mistakes.isEmpty) {
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
      for (int i = 0; i < mistakes.length; i++) {
        final String left = (i == 0)
            ? text.substring(0, mistakes[i].offset)
            : text.substring(
                mistakes[i - 1].offset + mistakes[i - 1].length,
                mistakes[i].offset,
              );
        if (left.isNotEmpty) children.add(TextSpan(text: left, style: style));
        final String mid = text.substring(
          mistakes[i].offset,
          mistakes[i].offset + mistakes[i].length,
        );
        children.add(
          TextSpan(
            text: mid,
            style: style?.merge(errorStyle) ?? errorStyle,
            // Callback
            recognizer: TapGestureRecognizer()
              ..onTapUp = (TapUpDetails details) {
                showDialog<Widget>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        children: [
                          Text(mistakes[i].issueType),
                          Text(mistakes[i].issueDescription),
                          Text(mistakes[i].message),
                          Text(mistakes[i].shortMessage),
                          const Divider(),
                          ...mistakes[i].replacements.map((m) => Text(m)),
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
          text.substring(mistakes.last.offset + mistakes.last.length);
      if (right.isNotEmpty) children.add(TextSpan(text: right, style: style));
    } catch (_) {
      return TextSpan(text: text, style: style);
    }

    return TextSpan(children: children, style: style);
  }
}

/// Test TextField
class SpellTextField extends StatefulWidget {
  final SpellTextEdittingController controller;
  final Duration debouncingDuration;

  const SpellTextField({
    Key? key,
    required this.controller,
    this.debouncingDuration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  _SpellTextFieldState createState() => _SpellTextFieldState();
}

class _SpellTextFieldState extends State<SpellTextField> {
  final LanguageTool _languageTool = LanguageTool();
  final Debouncing _debouncing =
      Debouncing(duration: const Duration(seconds: 3));

  String _textTemp = '';

  SpellTextEdittingController get _controller => widget.controller;

  Duration get _debouncingDuration => widget.debouncingDuration;

  @override
  void initState() {
    super.initState();
    _textTemp = _controller.text;
    _debouncing.duration = _debouncingDuration;

    // Try to check spell after few seconds after changing text
    _controller.addListener(() {
      if (_textTemp != _controller.text) {
        _textTemp = _controller.text;
        _controller.mistakes = [];
        _debouncing.debounce(() async {
          try {
            _controller.mistakes = await _languageTool.check(_textTemp);
            setState(() {});
          } catch (_) {}
        });
      }
    });
  }

  @override
  void dispose() {
    _debouncing.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
    );
  }
}
