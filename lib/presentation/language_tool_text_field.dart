import 'package:flutter/material.dart';
import 'package:languagetool_textfield/core/controllers/colored_text_editing_controller.dart';
import 'package:languagetool_textfield/core/enums/delay_type.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';
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

  ///
  final Duration delay;

  ///
  final DelayType delayType;

  /// Creates a widget that checks grammar errors.
  const LanguageToolTextField({
    required this.style,
    required this.decoration,
    required this.coloredController,
    required this.mistakePopup,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.delay = Duration.zero,
    this.delayType = DelayType.debouncing,
    super.key,
  });

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  ColoredTextEditingController? _langtoolController;
  static final LanguageToolClient _languageToolClient = LanguageToolClient(
    // A language code like en-US, de-DE, fr, or auto to guess
    // the language automatically.
    // language = 'auto' by default.
    language: 'en-US',
  );

  @override
  void initState() {
    super.initState();
    _langtoolController = ColoredTextEditingController(
        DebounceLangToolService(LangToolService(_languageToolClient), widget.delay));
    _langtoolController?.focusNode = _focusNode;
    _langtoolController?.popupWidget = widget.mistakePopup;
    _langtoolController?.addListener(_textControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    const _padding = 24.0;

    return ListenableBuilder(
      listenable: _langtoolController!,
      builder: (context, child) {
        final fetchError = _langtoolController?.fetchError;

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
              scrollController: _scrollController,
              focusNode: _focusNode,
              controller: _langtoolController,
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

  void _textControllerListener() =>
      widget.coloredController.scrollOffset = _scrollController.offset;

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
