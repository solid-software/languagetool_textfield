import 'package:languagetool_textfield/domain/api/language_check_service.dart';
import 'package:languagetool_textfield/domain/model/mistake.dart';
import 'package:throttling/throttling.dart';

/// Decorator for existing [LanguageCheckService].
/// Adds throttling for findMistakes() executing.
class ThrottlingLangToolService extends LanguageCheckService {
  final LanguageCheckService _baseService;
  final Throttling _throttling;

  /// Constructor
  ThrottlingLangToolService(
    this._baseService,
    Duration throttlingDuration,
  ) : _throttling = Throttling(duration: throttlingDuration);

  @override
  Future<List<Mistake>> findMistakes(String text) =>
      _throttling.throttle(() => _baseService.findMistakes(text))
          as Future<List<Mistake>>;
}
