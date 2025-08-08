import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
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

  /// {@macro flutter.widgets.editableText.onChanged}
  final ValueChanged<String>? onTextChange;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<String>? onTextSubmitted;

  /// Whether to center align the text field widget.
  final bool alignCenter;

  /// Creates a widget that checks grammar errors.
  const LanguageToolTextField({
    required LanguageToolController super.controller,
    this.mistakePopup,
    this.language = 'auto',
    this.onTextChange,
    this.onTextSubmitted,
    this.alignCenter = true,
    super.focusNode,
    super.undoController,
    super.decoration = const InputDecoration(),
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization = TextCapitalization.none,
    super.style,
    super.strutStyle,
    super.textAlign = TextAlign.start,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly = false,
    super.showCursor,
    super.autofocus = false,
    super.statesController,
    super.obscuringCharacter = '•',
    super.obscureText = false,
    super.autocorrect = true,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions = true,
    super.maxLines = 1,
    super.minLines,
    super.expands = false,
    super.maxLength,
    super.maxLengthEnforcement,
    super.inputFormatters,
    super.enabled,
    super.ignorePointers,
    super.cursorWidth = 2.0,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorColor,
    super.cursorErrorColor,
    super.selectionHeightStyle = ui.BoxHeightStyle.tight,
    super.selectionWidthStyle = ui.BoxWidthStyle.tight,
    super.keyboardAppearance,
    super.scrollPadding = const EdgeInsets.all(20.0),
    super.dragStartBehavior = DragStartBehavior.start,
    super.enableInteractiveSelection,
    super.selectionControls,
    super.onTap,
    super.onTapAlwaysCalled = false,
    super.onTapOutside,
    super.onTapUpOutside,
    super.mouseCursor,
    super.buildCounter,
    super.scrollController,
    super.scrollPhysics,
    super.autofillHints,
    super.contentInsertionConfiguration,
    super.clipBehavior = Clip.hardEdge,
    super.restorationId,
    super.stylusHandwritingEnabled = true,
    super.enableIMEPersonalizedLearning = true,
    super.contextMenuBuilder,
    super.canRequestFocus = true,
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
          onChanged: widget.onTextChange,
          onTap: widget.onTap,
          onTapAlwaysCalled: widget.onTapAlwaysCalled,
          onTapOutside: widget.onTapOutside,
          onTapUpOutside: widget.onTapUpOutside,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onTextSubmitted,
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
