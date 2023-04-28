import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

/// A TextField widget that checks the grammar using the given
/// [languageTool]
class LanguageToolTextField extends StatefulWidget {
  /// A style to use for the text being edited.
  final TextStyle style;

  /// A decoration of this [TextField].
  final InputDecoration decoration;

  /// A builder function used to build errors.
  final Widget Function()? mistakeBuilder;

  /// A Service to get mistakes from API
  final LanguageTool languageTool;

  /// User customization for mistake highlighting
  final HighlightStyle mistakeHighlightStyle;

  /// Creates a widget that checks grammar errors.
  const LanguageToolTextField({
    Key? key,
    required this.style,
    required this.decoration,
    required this.languageTool,
    this.mistakeHighlightStyle = const HighlightStyle(),
    this.mistakeBuilder,
  }) : super(key: key);

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  /// Initialize ColoredTextEditingController
  ColoredTextEditingController? _controller;

  @override
  void initState() {
    /// Creating an instance of DebounceLangToolService
    final DebounceLangToolService _debouncedLangService =
        DebounceLangToolService(
      LangToolService(widget.languageTool),
      const Duration(milliseconds: 500),
    );

    /// Setting ColoredTextEditingController with DebounceLangToolService and
    /// a Dialog trigger function
    _controller = ColoredTextEditingController(
      languageCheckService: _debouncedLangService,
      highlightStyle: widget.mistakeHighlightStyle,
      onMistakeTap: (
        Offset globalPosition,
        Color color,
        Mistake mistake,
      ) {
        createPopupEntry(
          globalPosition: globalPosition,
          context: context,
          mistake: mistake,
          color: color,
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: TextField(
          controller: _controller,
          style: widget.style,
          decoration: widget.decoration,
        ),
      ),
    );
  }
}
