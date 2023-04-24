import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:throttling/throttling.dart';

/// Implementation of language check service with throttling.
class ThrottlingLangToolService extends LanguageCheckService {
  /// Base language check service.
  final LanguageCheckService baseService;

  /// Throttling.
  final Throttling throttling;

  /// Implementation of LanguageCheckService with throttling.
  ThrottlingLangToolService(
    this.baseService,
    Duration throttlingDuration,
  ) : throttling = Throttling(duration: throttlingDuration);

  @override
  Future<List<Mistake>> findMistakes(String text) =>
      throttling.throttle(() => baseService.findMistakes(text))
          as Future<List<Mistake>>;
}
