import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

void main() => runApp(TestApp());

/// Testing app
class TestApp extends StatelessWidget {
  final SpellTextEdittingController _controller = SpellTextEdittingController();

  TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SpellTextField(
          controller: _controller,
          debouncingDuration: const Duration(seconds: 3),
        ),
      ),
    );
  }
}
