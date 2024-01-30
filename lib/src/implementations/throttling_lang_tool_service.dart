import 'package:languagetool_textfield/src/domain/language_check_service.dart';
import 'package:languagetool_textfield/src/domain/mistake.dart';
import 'package:languagetool_textfield/src/utils/result.dart';
import 'package:throttling/throttling.dart';

/// A language check service with debouncing.
class ThrottlingLangToolService extends LanguageCheckService {
  /// A base language check service that is used to interact
  /// with the language check API.
  final LanguageCheckService baseService;

  /// A throttling used to throttle the API calls.
  final Throttling<Future<Result<List<Mistake>>?>> throttling;

  /// Creates a new instance of the [ThrottlingLangToolService] class.
  ThrottlingLangToolService(
    this.baseService,
    Duration throttlingDuration,
  ) : throttling = Throttling(duration: throttlingDuration);

  @override
  Future<Result<List<Mistake>>?> findMistakes(String text) async =>
      throttling.throttle(() => baseService.findMistakes(text));

  @override
  Future<void> dispose() async {
    throttling.close();
    await baseService.dispose();
  }
}
