import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

/// Example App widget
class App extends StatefulWidget {
  /// Initial constructor
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _languageTool = LanguageTool();
  DebounceLangToolService? _debouncedLangService;

  void _initializeLangService() {
    _debouncedLangService = DebounceLangToolService(
      LangToolService(_languageTool),
      const Duration(milliseconds: 500),
    );
  }

  @override
  void initState() {
    _initializeLangService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LanguageToolTextField(
        langService: _debouncedLangService!,
        style: TextStyle(),
        decoration: InputDecoration(),
        mistakeBuilder: (){
          return Container();
        },
      ),
    );
  }
}
