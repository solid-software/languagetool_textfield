import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:throttling/throttling.dart';

class ThrottlingLangToolService extends LanguageCheckService {
  final LanguageCheckService baseService;
  final Throttling throttling;

  ThrottlingLangToolService(
    this.baseService,
    Duration throttlingDuration,
  ) : throttling = Throttling(duration: throttlingDuration);

  @override
  Future<List<Mistake>> findMistakes(String text) =>
      throttling.throttle(() => baseService.findMistakes(text))
          as Future<List<Mistake>>;
}
