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

  /// Initialize DebounceLangToolService
  final DebounceLangToolService _debouncedLangService;

  /// Initialize ColoredTextEditingController
  final ColoredTextEditingController controller =
      ColoredTextEditingController();

  /// Set DebounceLangToolService
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
        coloredController: controller,
      ),
    );
  }
}
