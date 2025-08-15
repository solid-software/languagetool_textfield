import 'package:languagetool_textfield/src/domain/mistake.dart';
import 'package:languagetool_textfield/src/utils/result.dart';

/// A base language check service.
abstract class LanguageCheckService {
  /// Gets the current language code used for language checking.
  ///
  /// Returns a string representing the language code (e.g., 'en-US', 'de-DE').
  String get language;

  /// Sets the language code to be used for language checking.
  ///
  /// [language] A string representing the language code (e.g., 'en-US', 'de-DE').
  /// This determines which language rules will be applied during text analysis.
  set language(String language);

  /// Creates a new instance of the [LanguageCheckService] class.
  const LanguageCheckService();

  /// Returns found mistakes in the given [text].
  Future<Result<List<Mistake>>?> findMistakes(String text);

  /// Disposes resources of this [LanguageCheckService].
  Future<void> dispose() async {
    // does nothing by default, but implementations may need to use it
    return;
  }
}
