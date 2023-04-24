import 'package:language_tool/language_tool.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

/// Implementation of language check service with language tool service.
class LangToolService extends LanguageCheckService {
  /// Objects of this class are used to interact with LanguageTool API.
  final LanguageTool languageTool;

  /// Implementation of language check service with language tool service.
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
