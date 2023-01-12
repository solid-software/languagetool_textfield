import 'package:clock/clock.dart';
import 'package:example/src/main_page.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_text_field/controllers/timeout.dart' as tout;

void main() async {
  runApp(
    MaterialApp(
      home: const MainPage(),
      theme: ThemeData(
        colorSchemeSeed: Colors.lightBlue,
      ),
    ),
  );
}
