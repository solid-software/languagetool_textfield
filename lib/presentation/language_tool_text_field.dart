import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';

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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
