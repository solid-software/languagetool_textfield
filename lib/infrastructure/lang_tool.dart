import 'package:language_tool/language_tool.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

class LangToolService extends LanguageCheckService {
  final LanguageTool languageTool;
  final Duration debounceDuration;

  const LangToolService(this.languageTool, this.debounceDuration);

  @override
  Future<List<Mistake>> findMistakes(String text) {
    // TODO: implement findMistakes
    throw UnimplementedError();
  }
}