import 'package:flutter/material.dart';
import 'package:languagetool_textfield/core/controllers/colored_text_editing_controller.dart';
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
  final ColoredTextEditingController _controller =
      ColoredTextEditingController();
  final int _maxLines = 8; // max lines of the TextFiled

  /// Sends API request to get a list of Mistake
  Future<void> _check(String text) async {
    final list = await widget.langService.findMistakes(text);
    if (list.isNotEmpty) {
      _controller.setMistakes(list);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); // disposes controller
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: TextField(
          controller: _controller,
          maxLines: _maxLines,
          onChanged: _check,
          style: widget.style,
          decoration: widget.decoration,
        ),
      ),
    );
  }
}
