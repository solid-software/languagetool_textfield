import 'package:languagetool_textfield/src/domain/language_check_service.dart';
import 'package:languagetool_textfield/src/domain/mistake.dart';
import 'package:languagetool_textfield/src/utils/result.dart';
import 'package:throttling/throttling.dart';

/// A language check service with debouncing.
class ThrottlingLanguageCheckService extends LanguageCheckService {
  /// A base language check service that is used to interact
  /// with the language check API.
  final LanguageCheckService _languageCheckService;

  /// A throttling used to throttle the API calls.
  final Throttling<Future<Result<List<Mistake>>?>> _throttling;

  @override
  String get language => _languageCheckService.language;

  @override
  set language(String language) {
    _languageCheckService.language = language;
  }

  /// Creates a new instance of the [ThrottlingLanguageCheckService] class.
  ThrottlingLanguageCheckService(
    this._languageCheckService,
    Duration throttlingDuration,
  ) : _throttling = Throttling(duration: throttlingDuration);

  @override
  Future<Result<List<Mistake>>?> findMistakes(String text) async {
    return await _throttling
        .throttle(() => _languageCheckService.findMistakes(text));
  }

  // ignore: proper_super_calls
  @override
  Future<void> dispose() async {
    _throttling.close();
    await _languageCheckService.dispose();
  }
}
