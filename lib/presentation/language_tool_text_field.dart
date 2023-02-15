import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/api/language_check_service.dart';
import 'package:languagetool_textfield/domain/model/mistake_type.dart';
import 'package:languagetool_textfield/presentation/language_check_controller.dart';
import 'package:languagetool_textfield/presentation/mistake_tile.dart';

/// TextField that can search for mistakes in text.
/// You can provide search logic by implementing [LanguageCheckService]
/// or use implemented one by this library
class LanguageToolTextField extends StatefulWidget {
  /// Service for mistake searching
  final LanguageCheckService langService;

  /// Callback which allows dynamically generate style for substring
  final StyleResolver<MistakeType?> resolveStyle;

  /// Decoration of TextField
  final InputDecoration decoration;

  /// Callback for building widget in mistake popup
  final MistakeBuilder? mistakeBuilder;

  /// Constructor
  const LanguageToolTextField({
    Key? key,
    required this.langService,
    required this.resolveStyle,
    required this.decoration,
    this.mistakeBuilder,
  }) : super(key: key);

  @override
  State<LanguageToolTextField> createState() => LanguageToolTextFieldState();
}

/// State of [LanguageToolTextField].
/// You can use GlobalKey<LanguageToolTextFieldState>
/// to control manually mistake searching by calling validate() method
class LanguageToolTextFieldState extends State<LanguageToolTextField> {
  final _layerLink = LayerLink();
  LanguageCheckController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = LanguageCheckController(
      text: '',
      resolveStyle: widget.resolveStyle,
      mistakeBuilder: widget.mistakeBuilder ?? MistakeTile.new,
      layerLink: _layerLink,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
        link: _layerLink,
        child: TextField(
          showCursor: true,
          decoration: widget.decoration,
          controller: _controller,
        ),
      );

  /// Fires mistake searching with provided [LanguageCheckService]
  Future<void> validate() async {
    final text = _controller?.text;
    if (text != null) {
      _controller?.mistakes = await widget.langService.findMistakes(text);
    }
  }
}
