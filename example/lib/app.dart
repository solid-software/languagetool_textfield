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

  static const List<MainAxisAlignment> alignments = [
    MainAxisAlignment.center,
    MainAxisAlignment.start,
    MainAxisAlignment.end,
  ];
  int currentAlignmentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            currentAlignmentIndex += 1;
            currentAlignmentIndex %= alignments.length;
          }),
        ),
        body: Column(
          mainAxisAlignment: alignments[currentAlignmentIndex],
          children: [
            LanguageToolTextField(
              style: const TextStyle(),
              decoration: const InputDecoration(),
              coloredController: _controller,
              mistakePopup: MistakePopup(popupRenderer: PopupOverlayRenderer()),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
