import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/utils/error_wrapper.dart';

/// A base language check service.
abstract class LanguageCheckService {
  /// Creates a new instance of the [LanguageCheckService] class.
  const LanguageCheckService();

  /// Returns found mistakes in the given [text].
  Future<ErrorWrapper<List<Mistake>>> findMistakes(String text);
  
  /// Disposes resources of this [LanguageCheckService].
  Future<void> dispose() async {
    // does nothing by default, but implementations may need to use it
    return;
  }
}
