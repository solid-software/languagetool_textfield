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

  /// The maximum number of lines to show at one time, wrapping if necessary.
  final int? maxLines;

  /// The minimum number of lines to occupy when the content spans fewer lines.
  final int? minLines;

  /// Whether this widget's height will be sized to fill its parent.
  final bool expands;

  /// Creates a widget that checks grammar errors.
  const LanguageToolTextField({
    required this.style,
    required this.decoration,
    required this.coloredController,
    required this.mistakePopup,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    super.key,
  });

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.coloredController.focusNode = focusNode;
    widget.coloredController.popupWidget = widget.mistakePopup;
  }

  @override
  Widget build(BuildContext context) {
    const _padding = 24.0;

    return ListenableBuilder(
      listenable: widget.coloredController,
      builder: (context, child) {
        final fetchError = widget.coloredController.fetchError;

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

        return Padding(
          padding: const EdgeInsets.all(_padding),
          child: Center(
            child: TextField(
              focusNode: focusNode,
              controller: widget.coloredController,
              style: widget.style,
              decoration: inputDecoration,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              expands: widget.expands,
            ),
          ),
        );
      },
    );
  }
}
