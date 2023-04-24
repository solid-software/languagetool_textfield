import 'package:languagetool_textfield/domain/mistake.dart';

/// Base language check service.
abstract class LanguageCheckService {
  /// Base language check service constructor.
  const LanguageCheckService();

  /// Function that finds mistakes in given text.
  Future<List<Mistake>> findMistakes(String text);
}
