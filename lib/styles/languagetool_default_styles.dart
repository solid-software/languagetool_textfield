import 'package:flutter/material.dart';
import 'package:languagetool_text_field/styles/app_colors.dart';

/// Abstract class with different predeined styles for different error types
abstract class LanguageToolDefaultStyles {
  /// Style of the right text
  static const TextStyle noMistakeStyle = TextStyle(
    fontFamily: "Georgia",
    color: Colors.black,
    fontSize: 14,
    height: 1.5,
  );

  /// Standart typographical  mistake style
  static const TextStyle typographicalMistakeStyle = TextStyle(
    color: Colors.black,
    fontFamily: "Georgia",
    // decoration: TextDecoration.underline,
    // decorationColor: Color.fromARGB(255, 255, 89, 77),
    // decorationThickness: 4,
    backgroundColor: AppColors.lightYellowHighlight,
    fontSize: 14,
    height: 1.5,
  );

  /// Standart grammar mistake style
  static const TextStyle grammarMistakeStyle = TextStyle(
    color: Colors.black,
    fontFamily: "Georgia",
    // decoration: TextDecoration.underline,
    // decorationColor: Color.fromARGB(255, 255, 222, 77),
    // decorationThickness: 4,
    backgroundColor: AppColors.lightRedHighlight,
    fontSize: 14,
    height: 1.5,
  );

  /// Standart style mistake style
  static const TextStyle styleMistakeStyle = TextStyle(
    color: Colors.black,
    fontFamily: "Georgia",
    // decoration: TextDecoration.underline,
    // decorationColor: Color.fromARGB(255, 255, 222, 77),
    // decorationThickness: 4,
    backgroundColor: AppColors.lightGreenHighlight,
    fontSize: 14,
    height: 1.5,
  );

  /// Standart unidentified mistake style
  static const TextStyle defaulMistakeStyle = TextStyle(
    color: Colors.black,
    fontFamily: "Georgia",

    // decoration: TextDecoration.underline,
    // decorationColor: Color.fromARGB(255, 255, 222, 77),
    // decorationThickness: 4,
    backgroundColor: AppColors.lightBlueHighlight,
    fontSize: 14,
    height: 1.5,
  );
}
