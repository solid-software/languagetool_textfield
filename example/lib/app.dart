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
  static final DebounceLangToolService _debouncedLangService =
      DebounceLangToolService(
    LangToolService(_languageTool),
    const Duration(milliseconds: 500),
  );

  /// Initialize ColoredTextEditingController
  final ColoredTextEditingController _controller =
      ColoredTextEditingController(languageCheckService: _debouncedLangService);

  @override
  Widget build(BuildContext context) {
    const _popupWidth = 250.0;
    const _popupHeight = 150.0;

    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          LanguageToolTextField(
            style: const TextStyle(),
            decoration: const InputDecoration(),
            coloredController: _controller,
            mistakePopup: LanguageToolMistakePopup(
              width: _popupWidth,
              height: _popupHeight,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
