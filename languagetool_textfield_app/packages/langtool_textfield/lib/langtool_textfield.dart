library langtool_textfield;

import "package:flutter/material.dart";
import 'package:langtool_textfield/controllers/custom_text_field_controller.dart';
import 'package:language_tool/language_tool.dart';

/// TextField widget that makes use of Languagetool API package and checks the
/// entered text for different kinds mistakes
class LanguageToolTextField extends StatefulWidget {
  /// Height of the Box, where the TextField is shown
  final double height;

  /// Width of the Box, where the TextField is shown
  final double width;

  /// Input decoration of the TextField
  final InputDecoration? decoration;

  /// Highlite style mistake with this specified TextStyle. If this is not stated, uses default instead
  final TextStyle? styleMistakeStyle;

  /// Highlite grammar mistake with this specified TextStyle. If this is not stated, uses default instead
  final TextStyle? grammarMistakeStyle;

  /// Highlite typographical mistake with this specified TextStyle. If this is not stated, uses default instead
  final TextStyle? typographicalMistakeStyle;

  /// default highlight for all unclassified mistakes. If this is not stated, uses default instead
  final TextStyle? defaultMistakeStyle;

  /// Constructor
  const LanguageToolTextField({
    /// Height of the Widget
    required this.height,

    /// Height of the Widget
    required this.width,
    required this.decoration,
    this.styleMistakeStyle,
    this.grammarMistakeStyle,
    this.typographicalMistakeStyle,
    this.defaultMistakeStyle,
    super.key,
  });

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  final tool = LanguageTool();
  late final CustomTextFieldController controller;

  @override
  void initState() {
    controller = CustomTextFieldController(
      text: '',
      styleMistakeStyle: widget.styleMistakeStyle,
      defaulMistakeStyle: widget.defaultMistakeStyle,
      grammarMistakeStyle: widget.grammarMistakeStyle,
      typographicalMistakeStyle: widget.typographicalMistakeStyle,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextField(
        showCursor: true,
        decoration: widget.decoration,
        onChanged: (value) {
          controller.updateValidation(context, value);
          // controller.mistakes = await tool.check(value);
        },
        cursorWidth: 1,
        maxLines: 10,
        controller: controller,
      ),
    );
  }
}
