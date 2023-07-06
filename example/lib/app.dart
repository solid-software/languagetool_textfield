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
  /// Initialize LanguageToolClient
  static final LanguageToolClient _languageTool = LanguageToolClient();

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
        body: Column(
          mainAxisAlignment: alignments[currentAlignmentIndex],
          children: [
            LanguageToolTextField(
                  // scrollPadding: EdgeInsets.all(20.0),
                  // keyboardType: TextInputType.multiline,
                  maxLines: 99999,
                  style: const TextStyle(),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blueGrey),),
                          focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.blueGrey),),
                          ),
                      
                  coloredController: _controller,
                  mistakePopup: MistakePopup(
                    popupRenderer: PopupOverlayRenderer(),
                  ),
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
            )
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
