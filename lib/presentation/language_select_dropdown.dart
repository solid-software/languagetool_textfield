import 'package:flutter/material.dart';
import 'package:languagetool_textfield/core/dataclasses/language/supported_language.dart';
import 'package:languagetool_textfield/domain/language_fetch_service.dart';
import 'package:languagetool_textfield/domain/typedefs.dart';

/// A DropdownButton which allows the user to select a language among the
/// languages supported by the API.
class LanguageSelectDropdown extends StatefulWidget {
  /// A [LanguageFetchService] which will be used by this
  /// [LanguageSelectDropdown] to fetch the supported language list.
  final LanguageFetchService languageFetchService;

  /// A callback which is called when a new
  final LanguageSelectCallback onSelected;

  /// Creates a new [LanguageSelectDropdown].
  const LanguageSelectDropdown({
    required this.languageFetchService,
    required this.onSelected,
    super.key,
  });

  @override
  State<LanguageSelectDropdown> createState() => _LanguageSelectDropdownState();
}

class _LanguageSelectDropdownState extends State<LanguageSelectDropdown> {
  static const SupportedLanguage _auto = SupportedLanguage(
    name: 'Automatically',
    code: 'auto',
    longCode: 'auto',
  );
  final Set<SupportedLanguage> _languages = {_auto};
  SupportedLanguage _selectedLanguage = _auto;

  @override
  void initState() {
    super.initState();
    _fetchLanguages();
  }

  Future<void> _fetchLanguages() async {
    final languages = await widget.languageFetchService.fetchLanguages();

    if (!mounted) return;

    setState(
      () => _languages
        ..addAll(languages)
        ..removeWhere(
          (lang) =>
              lang.code == lang.longCode &&
              languages.any(
                (e) => e.code == lang.code && e.longCode != lang.longCode,
              ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SupportedLanguage>(
      onChanged: _onLanguageSelected,
      value: _selectedLanguage,
      items: _languages
          .map(
            (language) => DropdownMenuItem(
              value: language,
              child: Text(language.name),
            ),
          )
          .toList(growable: false),
    );
  }

  void _onLanguageSelected(SupportedLanguage? language) {
    if (language == null) return;
    setState(() => _selectedLanguage = language);
    widget.onSelected(language);
  }
}
