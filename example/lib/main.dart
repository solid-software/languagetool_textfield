import 'package:example/src/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: const MainPage(),
      theme: ThemeData(colorSchemeSeed: Colors.lightBlue),
    ),
  );
}
