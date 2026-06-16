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
// ignore: prefer_match_file_name, prefer-match-file-name
class App extends StatefulWidget {
  /// Example app constructor
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Set<String> _dictionary = {};
  final _addWordController = TextEditingController();

  LanguageToolController? _spellCheckController;

  LanguageToolController _nonNullController() {
    return _spellCheckController ??= LanguageToolController(
      languageCheckService: InMemoryDictionaryLanguageCheckService(
        languageCheckService: ThrottlingLanguageCheckService(
          LanguageToolService(LanguageToolClient()),
          const Duration(milliseconds: 250),
        ),
        shouldIgnoreMistake: (mistake, text) {
          final word = text.substring(mistake.offset, mistake.endOffset);

          return _dictionary.contains(word);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spellCheckController = _nonNullController();

    return Material(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              LanguageToolTextField(
                controller: spellCheckController,
                language: 'en-US',
                mistakePopup: MistakePopup(
                  popupRenderer: PopupOverlayRenderer(),
                  mistakeBuilder: ({
                    required LanguageToolController controller,
                    required Mistake mistake,
                    required Offset mistakePosition,
                    required PopupOverlayRenderer popupRenderer,
                  }) {
                    return LanguageToolMistakePopup(
                      popupRenderer: popupRenderer,
                      mistake: mistake,
                      mistakePosition: mistakePosition,
                      controller: controller,
                      addWordToDictionary: (word) async {
                        setState(() => _dictionary = {..._dictionary, word});
                      },
                    );
                  },
                ),
              ),
              ValueListenableBuilder(
                valueListenable: spellCheckController,
                builder: (_, __, ___) => CheckboxListTile(
                  title: const Text("Enable spell checking"),
                  value: spellCheckController.isEnabled,
                  onChanged: (value) =>
                      spellCheckController.isEnabled = value ?? false,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dictionary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _addWordController,
                              decoration: const InputDecoration(
                                labelText: 'Add word to dictionary',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (_) => _addWord(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _addWord,
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dictionary Words (${_dictionary.length})',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          if (_dictionary.isNotEmpty)
                            TextButton(
                              onPressed: _clearAllWords,
                              child: const Text('Clear All'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_dictionary.isEmpty)
                        const Center(
                          child: Text(
                            'No words in dictionary',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      else
                        for (final word in _dictionary)
                          ListTile(
                            title: Text(word),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeWord(word),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addWord() {
    final word = _addWordController.text.trim();

    if (word.isNotEmpty && !_dictionary.contains(word)) {
      setState(() {
        _dictionary = {..._dictionary, word};
        _addWordController.clear();
        _spellCheckController?.recheckText();
      });
    }
  }

  void _removeWord(String word) {
    setState(() {
      _dictionary = _dictionary.difference({word});
      _spellCheckController?.recheckText();
    });
  }

  void _clearAllWords() {
    setState(() {
      _dictionary = {};
      _spellCheckController?.recheckText();
    });
  }

  @override
  void dispose() {
    _spellCheckController?.dispose();
    _addWordController.dispose();
    super.dispose();
  }
}
