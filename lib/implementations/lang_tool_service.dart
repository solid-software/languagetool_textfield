import 'package:language_tool/language_tool.dart';
import 'package:languagetool_textfield/domain/api/language_check_service.dart';
import 'package:languagetool_textfield/domain/model/mistake.dart';
import 'package:languagetool_textfield/domain/model/mistake_type.dart';

class LangToolService extends LanguageCheckService {
  final LanguageTool languageTool;

  const LangToolService(this.languageTool);

  @override
  Future<List<Mistake>> findMistakes(String text) async {
    final writingMistakes = await languageTool.check(text);
    final mistakes = writingMistakes.map(
      (m) => Mistake(
        description: m.issueDescription,
        offset: m.offset,
        length: m.length,
        replacements: m.replacements,
        type: MistakeType.values.firstWhere(
          (type) => type.name == m.issueType,
          orElse: () => MistakeType.unknown,
        ),
      ),
    );

    return mistakes.toList();
  }
}
