import 'package:languagetool_textfield/domain/model/mistake.dart';
import 'package:languagetool_textfield/presentation/language_tool_text_field.dart';

/// Interface for language service,
/// which can find incorrect substring in provided text.
/// You can provide your own implementation
/// and use it in [LanguageToolTextField].
abstract class LanguageCheckService {
  /// Base const constructor
  const LanguageCheckService();

  /// Method for mistake searching in given text.
  /// It returns [Future] to make possible using asynchronous APIs
  Future<List<Mistake>> findMistakes(String text);
}
