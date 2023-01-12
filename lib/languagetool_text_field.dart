library languagetool_text_field;

import "package:flutter/material.dart";

import 'package:languagetool_text_field/controllers/custom_text_field_controller.dart';
import 'package:languagetool_text_field/controllers/debouncer.dart';
import 'package:languagetool_text_field/styles/languagetool_default_styles.dart';

/// TextField widget that makes use of Languagetool API package and checks the
/// entered text for different kinds mistakes
class LanguageToolTextField extends StatefulWidget {
  /// Input decoration of the TextField
  final InputDecoration? decoration;

  /// TextStyle for style mistake
  final TextStyle? styleMistakeStyle;

  /// TextStyle for grammar mistake
  final TextStyle? grammarMistakeStyle;

  /// TextStyle for typographical mistake
  final TextStyle? typographicalMistakeStyle;

  /// TextStyle for unidentified mistake
  final TextStyle? defaultMistakeStyle;

  /// Cursor width
  final double? cursorWidth;

  /// Maximum number of lines in the TextField
  final int? maxLines;

  /// Constructor
  const LanguageToolTextField({
    required this.decoration,
    this.styleMistakeStyle,
    this.grammarMistakeStyle,
    this.typographicalMistakeStyle,
    this.defaultMistakeStyle,
    this.cursorWidth,
    this.maxLines,
    super.key,
  });

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  CustomTextFieldController controller = CustomTextFieldController(text: '');
  final _textCheckDebouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: LanguageToolDefaultStyles.noMistakeStyle,
      showCursor: true,
      decoration: widget.decoration,
      onChanged: (value) async {
        controller.nullMistakes();

        _textCheckDebouncer.run(
          () async {
            await controller.updateValidation(value);
          },
        );
      },
      cursorWidth: widget.cursorWidth ?? 1,
      maxLines: widget.maxLines ?? 1,
      controller: controller,
    );
  }
}
