import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextInputType? keyboardType;
  final Color? cursorColor;
  final bool autoFocus;
  final FocusNode? focusNode;
  final Brightness? keyboardAppearance;
  final bool autocorrect;
  final bool readOnly;
  final MouseCursor? mouseCursor;
  final bool alignCenter;
  final StrutStyle? strutStyle;
  final TextAlignVertical? textAlignVertical;
  final TextCapitalization textCapitalization;
  final bool? showCursor;
  final bool obscureText;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLength;
  final VoidCallback? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final EdgeInsets scrollPadding;
  final ScrollPhysics? scrollPhysics;
  final bool? enableInteractiveSelection;
  final InputCounterWidgetBuilder? buildCounter;
  final Iterable<String>? autofillHints;
  final String obscuringCharacter;
  final DragStartBehavior dragStartBehavior;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final String? restorationId;
  final TextSelectionControls? selectionControls;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final Clip clipBehavior;
  final bool enableIMEPersonalizedLearning;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final bool onTapAlwaysCalled;
  final bool? ignorePointers;
  final bool stylusHandwritingEnabled;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final bool canRequestFocus;
  final UndoHistoryController? undoController;
  final Color? cursorErrorColor;
  final WidgetStatesController? statesController;
  final bool? cursorOpacityAnimates;

  /// Creates a widget that checks grammar errors.
  const LanguageToolTextField({
    required this.controller,
    this.style,
    this.decoration = const InputDecoration(),
    this.language = 'auto',
    this.mistakePopup,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.cursorColor,
    this.autocorrect = true,
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
    this.strutStyle,
    this.textAlignVertical,
    this.textCapitalization = TextCapitalization.none,
    this.showCursor,
    this.obscureText = false,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.maxLength,
    this.onEditingComplete,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.scrollPhysics,
    this.enableInteractiveSelection,
    this.buildCounter,
    this.autofillHints,
    this.obscuringCharacter = '•',
    this.dragStartBehavior = DragStartBehavior.start,
    this.onAppPrivateCommand,
    this.restorationId,
    this.selectionControls,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.clipBehavior = Clip.hardEdge,
    this.enableIMEPersonalizedLearning = true,
    this.magnifierConfiguration,
    this.onTapAlwaysCalled = false,
    this.ignorePointers,
    this.stylusHandwritingEnabled = true,
    this.contentInsertionConfiguration,
    this.canRequestFocus = true,
    this.undoController,
    this.cursorErrorColor,
    this.statesController,
    this.cursorOpacityAnimates,
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
          keyboardType: widget.keyboardType,
          autofocus: widget.autoFocus,
          readOnly: widget.readOnly,
          mouseCursor: widget.mouseCursor,
          onChanged: widget.onTextChange,
          onSubmitted: widget.onTextSubmitted,
          onTap: widget.onTap,
          onTapOutside: widget.onTapOutside,
          strutStyle: widget.strutStyle,
          textAlignVertical: widget.textAlignVertical,
          textCapitalization: widget.textCapitalization,
          showCursor: widget.showCursor,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          enableSuggestions: widget.enableSuggestions,
          obscureText: widget.obscureText,
          maxLength: widget.maxLength,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          onEditingComplete: widget.onEditingComplete,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          cursorWidth: widget.cursorWidth,
          cursorHeight: widget.cursorHeight,
          cursorRadius: widget.cursorRadius,
          scrollPadding: widget.scrollPadding,
          scrollPhysics: widget.scrollPhysics,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          buildCounter: widget.buildCounter,
          autofillHints: widget.autofillHints,
          obscuringCharacter: widget.obscuringCharacter,
          dragStartBehavior: widget.dragStartBehavior,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          restorationId: widget.restorationId,
          selectionControls: widget.selectionControls,
          selectionHeightStyle: widget.selectionHeightStyle,
          selectionWidthStyle: widget.selectionWidthStyle,
          clipBehavior: widget.clipBehavior,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          magnifierConfiguration: widget.magnifierConfiguration,
          onTapAlwaysCalled: widget.onTapAlwaysCalled,
          ignorePointers: widget.ignorePointers,
          stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
          contentInsertionConfiguration: widget.contentInsertionConfiguration,
          canRequestFocus: widget.canRequestFocus,
          undoController: widget.undoController,
          cursorErrorColor: widget.cursorErrorColor,
          statesController: widget.statesController,
          cursorOpacityAnimates: widget.cursorOpacityAnimates,
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
