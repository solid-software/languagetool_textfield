import 'package:languagetool_textfield/domain/api_request_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

/// A base language check service.
abstract class LanguageCheckService {
  /// Creates a new instance of the [LanguageCheckService] class.
  const LanguageCheckService();

  /// Returns found mistakes in the given [text].
  Future<List<Mistake>> findMistakes(
    String text, {
    required String checkLanguage,
    required bool isPicky,
  });

  /// Disposes resources of this [LanguageCheckService].
  Future<void> dispose() async {
    // does nothing by default, but implementations may need to use it
    return;
  }
}
