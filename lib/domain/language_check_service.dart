import 'package:languagetool_textfield/domain/mistake.dart';

/// Base language check service.
abstract class LanguageCheckService {
  /// Creates a new instance of the [LanguageCheckService] class.
  const LanguageCheckService();

  /// Function that finds mistakes in given text.
  Future<List<Mistake>> findMistakes(String text);
}
