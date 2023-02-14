import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/api/language_check_service.dart';
import 'package:languagetool_textfield/domain/model/mistake.dart';
import 'package:languagetool_textfield/domain/model/mistake_type.dart';
import 'package:languagetool_textfield/presentation/language_check_controller.dart';
import 'package:languagetool_textfield/presentation/mistake_tile.dart';

class LanguageToolTextField extends StatefulWidget {
  final LanguageCheckService langService;
  final TextStyle Function(MistakeType?) resolveStyle;
  final InputDecoration decoration;
  final Widget Function(Mistake)? mistakeBuilder;

  const LanguageToolTextField({
    Key? key,
    required this.langService,
    required this.resolveStyle,
    required this.decoration,
    this.mistakeBuilder,
  }) : super(key: key);

  @override
  State<LanguageToolTextField> createState() => _LanguageToolTextFieldState();
}

class _LanguageToolTextFieldState extends State<LanguageToolTextField> {
  final layerLink = LayerLink();
  LanguageCheckController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = LanguageCheckController(
      text: '',
      service: widget.langService,
      resolveStyle: widget.resolveStyle,
      mistakeBuilder: widget.mistakeBuilder ?? MistakeTile.new,
      layerLink: layerLink,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CompositedTransformTarget(
        link: layerLink,
        child: TextField(
          showCursor: true,
          decoration: widget.decoration,
          controller: _controller,
        ),
      );
}
