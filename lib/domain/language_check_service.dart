// ignore_for_file: public_member_api_docs

import 'package:languagetool_textfield/domain/mistake.dart';

abstract class LanguageCheckService {
  const LanguageCheckService();

  Future<List<Mistake>> findMistakes(String text);
}
