import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';

/// Widget for checking grammar errors.
class LanguageToolTextField extends StatefulWidget {
  /// Service for checking errors.
  final LanguageCheckService langService;

  /// The style to use for the text being edited.
  final TextStyle style;

  /// Decoration of widget
  final InputDecoration decoration;

  /// Will build custom errors based on state.
  final Widget Function()? mistakeBuilder;

  /// Creates a widget that checks grammar errors.
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
