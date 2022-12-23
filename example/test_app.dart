import 'package:flutter/material.dart';
import 'package:languagetool_textfield/spell_text_editing_controller.dart';

void main() => runApp(TestApp());

/// Testing app
class TestApp extends StatelessWidget {
  final SpellTextEditingController _controller = SpellTextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TextField(
          controller: _controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
      ),
    );
  }
}
