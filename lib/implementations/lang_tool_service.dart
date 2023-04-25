import 'package:language_tool/language_tool.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

/// An implementation of language check service with language tool service.
class LangToolService extends LanguageCheckService {
  /// An instance of this class that is used to interact with LanguageTool API.
  final LanguageTool languageTool;

  /// Creates a new instance of the [LangToolService].
  const LangToolService(this.languageTool);

  @override
  Future<List<Mistake>> findMistakes(String text) async {
    final writingMistakes = await languageTool.check(text);
    final mistakes = writingMistakes.map(
      (m) => Mistake(
        message: m.message,
        type: m.issueType,
        offset: m.offset,
        length: m.length,
        replacements: m.replacements,
      ),
    );

    return mistakes.toList();
  }
}
