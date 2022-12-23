library languagetool_textfield;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:language_tool/language_tool.dart';
import 'package:throttling/throttling.dart';

/// Test TextEditingController
class SpellTextEditingController extends TextEditingController {
  // Language Tool free API gives us 20 calls per minute free of charge.
  // This means we can call the API every 3 seconds and not hit the limit.
  final Debouncing _debounce = Debouncing(duration: const Duration(seconds: 3));
  final LanguageTool _languageTool = LanguageTool();
  String _textPreviousValue = '';
  List<WritingMistake> _mistakeList = [];

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
    final hasTextChanged = _textPreviousValue != text;
    if (hasTextChanged) {
      _textPreviousValue = text;
      _mistakeList.clear();
      _debounce.debounce(() async {
        try {
          _mistakeList = await _languageTool.check(text);
          notifyListeners();
        } catch (_) {
          // Empty exception handler (for now)
        }
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
    if (_mistakeList.isEmpty) return TextSpan(text: text, style: style);
    // Rebuild TextSpan based on mistakes
    final List<TextSpan> children = [];
    try {
      const TextStyle mistakeStyle = TextStyle(
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.wavy,
        decorationColor: Colors.red,
      );
      for (int i = 0; i < _mistakeList.length; i++) {
        final mistake = _mistakeList[i];
        final String textLeading;
        if (i == 0) {
          // Find text before first mistake
          textLeading = text.substring(0, mistake.offset);
        } else {
          // Find text between prev and current mistake
          final mistakePrev = _mistakeList[i - 1];
          textLeading = text.substring(
            mistakePrev.offset + mistakePrev.length,
            mistake.offset,
          );
        }
        if (textLeading.isNotEmpty) {
          children.add(TextSpan(text: textLeading, style: style));
        }
        // Find current mistake text
        final String textMistake = text.substring(
          mistake.offset,
          mistake.offset + mistake.length,
        );
        children.add(
          TextSpan(
            text: textMistake,
            style: style?.merge(mistakeStyle) ?? mistakeStyle,
            // Mistake text callback when tapped
            recognizer: TapGestureRecognizer()
              ..onTap = () => _mistakeCallback(context, mistake),
          ),
        );
      }
      // Find text after last mistake
      final String textTrailing =
          text.substring(_mistakeList.last.offset + _mistakeList.last.length);
      if (textTrailing.isNotEmpty) {
        children.add(TextSpan(text: textTrailing, style: style));
      }
    } catch (_) {
      return TextSpan(text: text, style: style);
    }

    return TextSpan(children: children, style: style);
  }

  void _mistakeCallback(BuildContext context, WritingMistake mistake) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            children: [
              Text(mistake.issueType),
              Text(mistake.issueDescription),
              Text(mistake.message),
              Text(mistake.shortMessage),
              const Divider(),
              ...mistake.replacements.map(
                (replacement) => TextButton(
                  child: Text(replacement),
                  // Replacement button callback when pressed
                  onPressed: () =>
                      _replacementCallback(context, mistake, replacement),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _replacementCallback(
    BuildContext context,
    WritingMistake mistake,
    String replacement,
  ) {
    _doReplacement(mistake, replacement);
    Navigator.of(context).pop();
  }

  void _doReplacement(WritingMistake mistake, String replacement) {
    // Replace mistake and move cursor to and of replacement
    text = text.substring(0, mistake.offset) +
        replacement +
        text.substring(mistake.offset + mistake.length);
    selection = TextSelection.fromPosition(
      TextPosition(offset: mistake.offset + replacement.length),
    );
  }
}
