import 'package:flutter/material.dart';
import 'package:language_tool/language_tool.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

/// A main screen widget demonstrating library usage example
class App extends StatefulWidget {
  /// Creates a new instance of main screen widget
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _langToolService = LangToolService(LanguageTool());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LanguageToolTextField(
            langService: _langToolService,
            controller: LanguageToolTextEditingController(
              text: 'OKAYOKAYOKAY',
              mistakes: [
                const Mistake(
                  message: 'bad',
                  type: 'bad',
                  offset: 2,
                  length: 2,
                ),
                const Mistake(
                  message: 'bad',
                  type: 'bad',
                  offset: 5,
                  length: 1,
                ),
                const Mistake(
                  message: 'bad',
                  type: 'bad',
                  offset: 7,
                  length: 3,
                ),
              ],
            ),
            style: const TextStyle(),
          ),
        ),
      ),
    );
  }
}
