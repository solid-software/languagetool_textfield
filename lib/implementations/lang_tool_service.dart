import 'package:language_tool/language_tool.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

class LangToolService extends LanguageCheckService {
  final LanguageTool languageTool;

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
