import 'package:languagetool_textfield/domain/model/mistake.dart';

abstract class LanguageCheckService {
  const LanguageCheckService();

  Future<List<Mistake>> findMistakes(String text);
}
