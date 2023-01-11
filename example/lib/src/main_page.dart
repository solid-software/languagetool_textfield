import 'package:flutter/material.dart';
import 'package:languagetool_text_field/languagetool_text_field.dart';

/// Main page, where we test the Languagetool_textfield widget
class MainPage extends StatelessWidget {
  /// Constructor
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    const double width = 500;
    const double heigth = 300;
    const double circularRadius = 15;
    const int maxLines = 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Demonstration"),
        centerTitle: true,
      ),
      body: Center(
        child: LanguageToolTextField(
          height: heigth,
          width: width,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(circularRadius),
            ),
          ),
          maxLines: maxLines,
          //defaultMistakeStyle: TextStyle(fontSize: 60),
          //styleMistakeStyle: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}