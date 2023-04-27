import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static final LanguageTool _languageTool = LanguageTool();
  final DebounceLangToolService _debouncedLangService;

  _AppState()
      : _debouncedLangService = DebounceLangToolService(
          LangToolService(_languageTool),
          const Duration(milliseconds: 500),
        );
  @override
  Widget build(BuildContext context) {
    return Material(
      child: LanguageToolTextField(
        langService: _debouncedLangService,
        style: const TextStyle(),
        decoration: const InputDecoration(),
        mistakeBuilder: () {
          return Container();
        },
      ),
    );
  }
}
