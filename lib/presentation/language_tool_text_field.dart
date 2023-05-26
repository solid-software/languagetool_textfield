import 'package:flutter/material.dart';
import 'package:languagetool_textfield/core/controllers/colored_text_editing_controller.dart';
import 'package:languagetool_textfield/utils/mistake_popup.dart';

/// A TextField widget that checks the grammar using the given
/// [coloredController]
class LanguageToolTextField extends StatefulWidget {
  /// A style to use for the text being edited.
  final TextStyle style;

  /// A decoration of this [TextField].
  final InputDecoration decoration;

  /// Color scheme to highlight mistakes
  final ColoredTextEditingController coloredController;

  /// Mistake popup window
  final MistakePopup mistakePopup;

  /// Creates a widget that checks grammar errors.
  const LanguageToolTextField({
    Key? key,
    required this.style,
    required this.decoration,
    required this.coloredController,
    required this.mistakePopup,
  }) : super(key: key);

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  /// An error that may have occurred during the API fetch.
  Object? _fetchError;

  @override
  void initState() {
    widget.coloredController.showPopup = widget.mistakePopup.show;
    widget.coloredController.addListener(() {
      if (mounted && widget.coloredController.fetchError != _fetchError) {
        setState(() => _fetchError = widget.coloredController.fetchError);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // it would probably look much better if the error would be shown on a
    // dedicated panel with field options
    final httpErrorText = Text(
      '$_fetchError',
      style: TextStyle(
        color: widget.coloredController.highlightStyle.misspellingMistakeColor,
      ),
    );

    final inputDecoration = widget.decoration.copyWith(
      suffix: _fetchError != null ? httpErrorText : null,
    );

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: TextField(
          controller: widget.coloredController,
          style: widget.style,
          decoration: inputDecoration,
        ),
      ),
    );
  }
}
