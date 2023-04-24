import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/presentation/widgets/custom_text_field_controller.dart';

class LanguageToolTextField extends StatefulWidget {
  final LanguageCheckService langService;
  final TextStyle style;
  final InputDecoration? decoration;
  final Widget Function()? mistakeBuilder;

  const LanguageToolTextField({
    Key? key,
    required this.langService,
    required this.style,
    this.decoration,
    this.mistakeBuilder,
  }) : super(key: key);

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  final _textFieldController = CustomTextFieldController(
    text: 'OkayOkayOkay',
    mistakes: [
      const Mistake(
        message: 'bad',
        type: 'bad',
        offset: 1,
        length: 2,
        replacements: ['1'],
      ),
      const Mistake(
        message: 'bad',
        type: 'bad',
        offset: 4,
        length: 2,
        replacements: ['1'],
      ),
      const Mistake(
        message: 'bad',
        type: 'bad',
        offset: 8,
        length: 2,
        replacements: ['1'],
      ),
    ],
  );
  static const _borderRadius = 15.0;
  static const _borderOpacity = 0.5;
  final _textFieldBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(_borderOpacity),
    ),
    borderRadius: BorderRadius.circular(_borderRadius),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      enableSuggestions: false,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: widget.decoration ??
          InputDecoration(
            focusedBorder: _textFieldBorder,
            enabledBorder: _textFieldBorder,
            border: _textFieldBorder,
          ),
      controller: _textFieldController,
    );
  }
}
