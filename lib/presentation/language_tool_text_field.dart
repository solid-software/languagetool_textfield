import 'package:flutter/material.dart';
import 'package:languagetool_textfield/core/controllers/language_tool_text_editing_controller.dart';
import 'package:languagetool_textfield/utils/mistake_popup.dart';
import 'package:languagetool_textfield/utils/popup_overlay_renderer.dart';

/// A TextField widget that checks the grammar using the given
/// [coloredController]
class LanguageToolTextField extends StatefulWidget {
  /// A style to use for the text being edited.
  final TextStyle? style;

  /// A decoration of this [TextField].
  final InputDecoration decoration;

  /// Color scheme to highlight mistakes
  final LanguageToolTextEditingController coloredController;

  /// Mistake popup window
  final MistakePopup? mistakePopup;

  /// The maximum number of lines to show at one time, wrapping if necessary.
  final int? maxLines;

  /// The minimum number of lines to occupy when the content spans fewer lines.
  final int? minLines;

  /// Whether this widget's height will be sized to fill its parent.
  final bool expands;

  /// A language code like en-US, de-DE, fr, or auto to guess
  /// the language automatically.
  /// ```language``` = 'auto' by default.
  final String language;

  /// Creates a widget that checks grammar errors.
  const LanguageToolTextField({
    required this.coloredController,
    this.style,
    this.decoration = const InputDecoration(),
    this.language = 'auto',
    this.mistakePopup,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    super.key,
  });

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  static const _padding = 24.0;

  final _focusNode = FocusNode();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final controller = widget.coloredController;

    controller.focusNode = _focusNode;
    controller.language = widget.language;
    final defaultPopup = MistakePopup(popupRenderer: PopupOverlayRenderer());
    controller.popupWidget = widget.mistakePopup ?? defaultPopup;

    controller.addListener(_textControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.coloredController,
      builder: (_, __) {
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
              focusNode: _focusNode,
              controller: widget.coloredController,
              scrollController: _scrollController,
              decoration: inputDecoration,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              expands: widget.expands,
              style: widget.style,
            ),
          ),
        );
      },
    );
  }

  void _textControllerListener() =>
      widget.coloredController.scrollOffset = _scrollController.offset;

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
