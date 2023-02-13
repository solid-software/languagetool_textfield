import 'mistake.dart';

abstract class LanguageCheckService {
  const LanguageCheckService();

  Future<List<Mistake>> findMistakes(String text);
}
