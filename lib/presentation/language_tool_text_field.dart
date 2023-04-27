import 'package:flutter/material.dart';
import 'package:languagetool_textfield/core/controllers/colored_text_editing_controller.dart';
import 'package:languagetool_textfield/domain/highlight_style.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';

/// A TextField widget that checks the grammar using the given [langService]
class LanguageToolTextField extends StatefulWidget {
  /// A service for checking errors.
  final LanguageCheckService langService;

  /// A style to use for the text being edited.
  final TextStyle style;

  /// A decoration of this [TextField].
  final InputDecoration decoration;

  /// A builder function used to build errors.
  final Widget Function()? mistakeBuilder;

  /// Color scheme to highlight mistakes
  final ColoredTextEditingController coloredController;

  /// Creates a widget that checks grammar errors.
  const LanguageToolTextField({
    Key? key,
    required this.langService,
    required this.style,
    required this.decoration,
    this.mistakeBuilder,
    required this.coloredController,
  }) : super(key: key);

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {

  /// Sends API request to get a list of Mistake
  Future<void> _check(String text) async {
    final mistakes = await widget.langService.findMistakes(text);
    if (mistakes.isNotEmpty) {
      widget.coloredController.highlightMistakes(mistakes);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: TextField(
          controller: widget.coloredController,
          onChanged: _check,
          style: widget.style,
          decoration: widget.decoration,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.coloredController.dispose();
  }
}
