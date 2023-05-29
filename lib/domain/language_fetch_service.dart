import 'package:languagetool_textfield/core/dataclasses/language/supported_language.dart';

/// A language fetch service interface.
abstract class LanguageFetchService {
  /// Creates a new [LanguageFetchService].
  const LanguageFetchService();

  /// Returns a Future List of APIs [SupportedLanguage]s.
  Future<List<SupportedLanguage>> fetchLanguages();
}
