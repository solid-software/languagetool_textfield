import 'package:flutter/material.dart';

abstract class LanguageToolStyles {
  static const TextStyle noMistakeStyle = TextStyle(
    color: Colors.black,
    fontSize: 14,
  );
  static const TextStyle typographicalMistakeStyle = TextStyle(
    color: Colors.black,
    decoration: TextDecoration.underline,
    // decorationColor: Color.fromARGB(255, 255, 89, 77),
    // decorationThickness: 4,
    backgroundColor: Color.fromARGB(255, 255, 238, 164),
    fontSize: 14,
  );
  static const TextStyle grammarMistakeStyle = TextStyle(
    color: Colors.black,
    decoration: TextDecoration.underline,
    // decorationColor: Color.fromARGB(255, 255, 222, 77),
    // decorationThickness: 4,
    backgroundColor: Color.fromARGB(255, 255, 161, 154),
    fontSize: 14,
  );
  static const TextStyle styleMistakeStyle = TextStyle(
    color: Colors.black,
    decoration: TextDecoration.underline,
    // decorationColor: Color.fromARGB(255, 255, 222, 77),
    // decorationThickness: 4,
    backgroundColor: Color.fromARGB(255, 178, 255, 150),
    fontSize: 14,
  );
  static const TextStyle defaulMistakeStyle = TextStyle(
    color: Colors.black,
    decoration: TextDecoration.underline,
    // decorationColor: Color.fromARGB(255, 255, 222, 77),
    // decorationThickness: 4,
    backgroundColor: Color.fromARGB(255, 142, 244, 255),
    fontSize: 14,
  );
}
