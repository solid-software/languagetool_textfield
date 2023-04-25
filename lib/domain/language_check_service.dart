import 'package:languagetool_textfield/domain/mistake.dart';

/// A base language check service.
abstract class LanguageCheckService {
  /// Creates a new instance of the [LanguageCheckService] class.
  const LanguageCheckService();

  /// Returns found mistakes in the given [text].
  Future<List<Mistake>> findMistakes(String text);
}
