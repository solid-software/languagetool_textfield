import 'package:flutter/material.dart';
import 'package:languagetool_textfield/src/core/controllers/language_tool_controller.dart';
import 'package:languagetool_textfield/src/utils/mistake_popup.dart';
import 'package:languagetool_textfield/src/utils/popup_overlay_renderer.dart';

/// A TextField widget that checks the grammar using the given
/// [LanguageToolController]
class LanguageToolTextField extends TextField {
  /// LanguageToolController to highlight mistakes
  @override
  LanguageToolController get controller =>
      super.controller as LanguageToolController? ?? LanguageToolController();

  /// Mistake popup window
  final MistakePopup? mistakePopup;

  /// A language code like en-US, de-DE, fr, or auto to guess
  /// the language automatically.
  /// ```language``` = 'auto' by default.
  final String language;

  /// Whether to center align the text field widget.
  final bool alignCenter;

  /// Creates a widget that checks grammar errors.
  const LanguageToolTextField({
    required LanguageToolController super.controller,
    this.mistakePopup,
    this.language = 'auto',
    this.alignCenter = true,
    super.onChanged,
    super.onSubmitted,
    super.focusNode,
    super.undoController,
    super.decoration,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly,
    super.showCursor,
    super.autofocus,
    super.statesController,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLines,
    super.minLines,
    super.expands,
    super.maxLength,
    super.maxLengthEnforcement,
    super.inputFormatters,
    super.enabled,
    super.ignorePointers,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorColor,
    super.cursorErrorColor,
    super.selectionHeightStyle,
    super.selectionWidthStyle,
    super.keyboardAppearance,
    super.scrollPadding,
    super.dragStartBehavior,
    super.enableInteractiveSelection,
    super.selectionControls,
    super.onTap,
    super.onTapAlwaysCalled,
    super.onTapOutside,
    super.onTapUpOutside,
    super.mouseCursor,
    super.buildCounter,
    super.scrollController,
    super.scrollPhysics,
    super.autofillHints,
    super.contentInsertionConfiguration,
    super.clipBehavior,
    super.restorationId,
    super.stylusHandwritingEnabled,
    super.enableIMEPersonalizedLearning,
    super.contextMenuBuilder,
    super.canRequestFocus,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
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

        final inputDecoration = widget.decoration?.copyWith(
          suffix: fetchError != null ? httpErrorText : null,
        );

        Widget childWidget = TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          scrollController: _scrollController,
          decoration: inputDecoration,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          style: widget.style,
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          textDirection: widget.textDirection,
          autofocus: widget.autofocus,
          statesController: widget.statesController,
          readOnly: widget.readOnly,
          showCursor: widget.showCursor,
          obscuringCharacter: widget.obscuringCharacter,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          enableSuggestions: widget.enableSuggestions,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          maxLength: widget.maxLength,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onTapAlwaysCalled: widget.onTapAlwaysCalled,
          onTapOutside: widget.onTapOutside,
          onTapUpOutside: widget.onTapUpOutside,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          ignorePointers: widget.ignorePointers,
          cursorWidth: widget.cursorWidth,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          cursorColor: widget.cursorColor,
          cursorErrorColor: widget.cursorErrorColor,
          scrollPadding: widget.scrollPadding,
          scrollPhysics: widget.scrollPhysics,
          keyboardAppearance: widget.keyboardAppearance,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          selectionControls: widget.selectionControls,
          buildCounter: widget.buildCounter,
          autofillHints: widget.autofillHints,
          mouseCursor: widget.mouseCursor,
          contextMenuBuilder: widget.contextMenuBuilder,
          spellCheckConfiguration: widget.spellCheckConfiguration,
          magnifierConfiguration: widget.magnifierConfiguration,
          undoController: widget.undoController,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          cursorOpacityAnimates: widget.cursorOpacityAnimates,
          selectionHeightStyle: widget.selectionHeightStyle,
          selectionWidthStyle: widget.selectionWidthStyle,
          dragStartBehavior: widget.dragStartBehavior,
          contentInsertionConfiguration: widget.contentInsertionConfiguration,
          clipBehavior: widget.clipBehavior,
          stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
          canRequestFocus: widget.canRequestFocus,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          restorationId: widget.restorationId,
        );

        if (widget.alignCenter) {
          childWidget = Center(child: childWidget);
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
