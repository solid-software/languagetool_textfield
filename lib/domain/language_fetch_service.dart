import 'package:language_tool/language_tool.dart';

/// A language fetch service interface.
abstract class LanguageFetchService {
  /// Creates a new [LanguageFetchService].
  const LanguageFetchService();

  /// Returns a Future List of [Language]s that are supported by the API.
  Future<List<Language>> fetchLanguages();
}
