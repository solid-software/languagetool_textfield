import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/api/language_check_service.dart';
import 'package:languagetool_textfield/presentation/language_check_controller.dart';

class LanguageToolTextField extends StatefulWidget {
  final LanguageCheckService langService;
  final TextStyle style;
  final InputDecoration decoration;
  final Widget Function()? mistakeBuilder;

  const LanguageToolTextField({
    Key? key,
    required this.langService,
    required this.style,
    required this.decoration,
    this.mistakeBuilder,
  }) : super(key: key);

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  LanguageCheckController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = LanguageCheckController(
      text: '',
      service: widget.langService,
    );
  }

  @override
  Widget build(BuildContext context) => TextField(
        showCursor: true,
        style: widget.style,
        decoration: widget.decoration,
        controller: _controller,
      );
}
