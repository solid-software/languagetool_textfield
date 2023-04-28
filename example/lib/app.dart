import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

/// Example App main page
class App extends StatefulWidget {
  /// Example app constructor
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// Initialize LanguageTool
  static final LanguageTool _languageTool = LanguageTool();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LanguageToolTextField(
        style: const TextStyle(),
        decoration: const InputDecoration(),
        languageTool: _languageTool,
      ),
    );
  }
}
