import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/presentation/widgets/language_tool_text_editing_controller.dart';

/// A TextField widget that checks the grammar using the given [langService]
class LanguageToolTextField extends StatefulWidget {
  /// A service for checking errors.
  final LanguageCheckService langService;

  /// A style to use for the text being edited.
  final TextStyle? style;

  /// A decoration of this [TextField].
  final InputDecoration? decoration;

  /// A builder function used to build errors.
  final Widget Function()? mistakeBuilder;

  /// A text controller used to highlight errors.
  final LanguageToolTextEditingController? controller;

  /// Creates a widget that checks grammar errors.
  const LanguageToolTextField({
    Key? key,
    required this.langService,
    required this.style,
    this.decoration,
    this.mistakeBuilder,
    this.controller,
  }) : super(key: key);

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  static const _borderRadius = 15.0;
  static const _borderOpacity = 0.5;

  final _textFieldController = LanguageToolTextEditingController();
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
      style: widget.style,
      decoration: widget.decoration ??
          InputDecoration(
            focusedBorder: _textFieldBorder,
            enabledBorder: _textFieldBorder,
            border: _textFieldBorder,
          ),
      controller: widget.controller ?? _textFieldController,
    );
  }
}
