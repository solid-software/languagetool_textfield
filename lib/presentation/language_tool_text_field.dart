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
    required this.style,
    required this.decoration,
    required this.coloredController,
    required this.mistakePopup,
    super.key,
  });

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  /// An error that may have occurred during the API fetch.
  Object? _fetchError;

  @override
  void initState() {
    widget.coloredController.showPopup = widget.mistakePopup.show;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const _padding = 24.0;

    return ListenableBuilder(
      listenable: widget.coloredController,
      builder: (context, child) {
        final fetchError = widget.coloredController.fetchError;
        if (_fetchError == fetchError && child != null) {
          return child;
        }

        // it would probably look much better if the error would be shown on a
        // dedicated panel with field options
        final httpErrorText = Text(
          '$fetchError',
          style: TextStyle(
            color:
                widget.coloredController.highlightStyle.misspellingMistakeColor,
          ),
        );

        final inputDecoration = widget.decoration.copyWith(
          suffix: fetchError != null ? httpErrorText : null,
        );

        return _PaddedLanguageToolTextField(
          padding: const EdgeInsets.all(_padding),
          controller: widget.coloredController,
          style: widget.style,
          decoration: inputDecoration,
        );
      },
      child: _PaddedLanguageToolTextField(
        padding: const EdgeInsets.all(_padding),
        controller: widget.coloredController,
        style: widget.style,
        decoration: widget.decoration,
      ),
    );
  }
}

class _PaddedLanguageToolTextField extends StatelessWidget {
  final ColoredTextEditingController controller;
  final EdgeInsetsGeometry padding;
  final TextStyle? style;
  final InputDecoration? decoration;

  const _PaddedLanguageToolTextField({
    required this.padding,
    required this.controller,
    this.style,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: TextField(
          controller: controller,
          style: style,
          decoration: decoration,
        ),
      ),
    );
  }
}
