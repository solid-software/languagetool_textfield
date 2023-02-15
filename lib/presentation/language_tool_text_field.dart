import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/api/language_check_service.dart';
import 'package:languagetool_textfield/domain/model/mistake_type.dart';
import 'package:languagetool_textfield/presentation/language_check_controller.dart';
import 'package:languagetool_textfield/presentation/mistake_tile.dart';

class LanguageToolTextField extends StatefulWidget {
  final LanguageCheckService langService;
  final StyleResolver<MistakeType?> resolveStyle;
  final InputDecoration decoration;
  final MistakeBuilder? mistakeBuilder;

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

  Future<void> validate() async {
    final text = _controller?.text;
    if (text != null) {
      _controller?.mistakes = await widget.langService.findMistakes(text);
    }
  }
}
