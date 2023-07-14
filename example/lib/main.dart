import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

void main() {
  runApp(
    const MaterialApp(
      home: App(),
    ),
  );
}

/// Example App main page
// ignore: prefer-match-file-name
class App extends StatefulWidget {
  /// Example app constructor
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// Initialize LanguageToolTextEditingController
  final LanguageToolTextEditingController _controller =
      LanguageToolTextEditingController();

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
        body: Column(
          mainAxisAlignment: alignments[currentAlignmentIndex],
          children: [
            LanguageToolTextField(
              coloredController: _controller,

              // A language code like en-US, de-DE, fr, or auto to guess
              // the language automatically.
              // language = 'auto' by default.
              language: 'en-US',
            ),
            DropdownMenu(
              hintText: "Select alignment...",
              onSelected: (value) => setState(() {
                currentAlignmentIndex = value ?? 0;
              }),
              dropdownMenuEntries: const [
                DropdownMenuEntry(value: 0, label: "Center alignment"),
                DropdownMenuEntry(value: 1, label: "Top alignment"),
                DropdownMenuEntry(value: 2, label: "Bottom alignment"),
              ],
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
