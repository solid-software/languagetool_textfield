import 'package:flutter/material.dart';
import 'package:languagetool_textfield/src/core/controllers/language_tool_controller.dart';
import 'package:languagetool_textfield/src/utils/mistake_popup.dart';
import 'package:languagetool_textfield/src/utils/popup_overlay_renderer.dart';

/// A TextField widget that checks the grammar using the given
/// [LanguageToolController]
class LanguageToolTextField extends StatefulWidget {
  /// A style to use for the text being edited.
  final TextStyle? style;

  /// A decoration of this [TextField].
  final InputDecoration decoration;

  /// Color scheme to highlight mistakes
  final LanguageToolController controller;

  /// Mistake popup window
  final MistakePopup? mistakePopup;

  /// Padding for the text field
  final EdgeInsetsGeometry? padding;

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

  /// Determine text alignment
  /// textAlign = [TextAlign.start] by default.
  final TextAlign textAlign;

  /// Determine text Direction
  final TextDirection? textDirection;

  final ValueChanged<String>? onTextChange;
  final ValueChanged<String>? onTextSubmitted;
  final VoidCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Color? cursorColor;
  final bool autoFocus;
  final FocusNode? focusNode;
  final Brightness? keyboardAppearance;
  final bool autocorrect;
  final bool readOnly;
  final MouseCursor? mouseCursor;
  final bool alignCenter;

  /// Creates a widget that checks grammar errors.
  const LanguageToolTextField({
    required this.controller,
    this.style,
    this.decoration = const InputDecoration(),
    this.language = 'auto',
    this.mistakePopup,
    this.padding = const EdgeInsets.all(24),
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.cursorColor,
    this.autocorrect = true,
    this.obscureText = false,
    this.autoFocus = false,
    this.readOnly = false,
    this.textInputAction,
    this.keyboardType,
    this.focusNode,
    this.keyboardAppearance,
    this.mouseCursor,
    this.onTap,
    this.onTapOutside,
    this.onTextChange,
    this.onTextSubmitted,
    this.alignCenter = true,
    super.key,
  });

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  FocusNode? _focusNode;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final controller = widget.controller;

    _focusNode = widget.focusNode ?? FocusNode();
    controller.focusNode = _focusNode;
    controller.language = widget.language;
    final defaultPopup = MistakePopup(popupRenderer: PopupOverlayRenderer());
    controller.popupWidget = widget.mistakePopup ?? defaultPopup;

    controller.addListener(_textControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (_, __) {
        final fetchError = widget.controller.fetchError;

        // it would probably look much better if the error would be shown on a
        // dedicated panel with field options
        final httpErrorText = Text(
          '$fetchError',
          style: TextStyle(
            color: widget.controller.highlightStyle.misspellingMistakeColor,
          ),
        );

        final inputDecoration = widget.decoration.copyWith(
          suffix: fetchError != null ? httpErrorText : null,
        );


        Widget childWidget = TextField(
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          focusNode: _focusNode,
          controller: widget.controller,
          scrollController: _scrollController,
          decoration: inputDecoration,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          expands: widget.expands,
          style: widget.style,
          cursorColor: widget.cursorColor,
          autocorrect: widget.autocorrect,
          textInputAction: widget.textInputAction,
          keyboardAppearance: widget.keyboardAppearance,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          autofocus: widget.autoFocus,
          readOnly: widget.readOnly,
          mouseCursor: widget.mouseCursor,
          onChanged: widget.onTextChange,
          onSubmitted: widget.onTextSubmitted,
          onTap: widget.onTap,
          onTapOutside: widget.onTapOutside,
        );

        if (widget.alignCenter) {
          childWidget = Center(child: childWidget);
        }

        if (widget.padding != null) {
          childWidget = Padding(
            padding: widget.padding!,
            child: childWidget,
          );
        }

        return childWidget;
      },
    );
  }

  void _textControllerListener() =>
      widget.controller.scrollOffset = _scrollController.offset;

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode?.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }
}
