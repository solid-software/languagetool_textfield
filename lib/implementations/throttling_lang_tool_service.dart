import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/utils/result.dart';
import 'package:throttling/throttling.dart';

/// A language check service with debouncing.
class ThrottlingLangToolService extends LanguageCheckService {
  /// A base language check service that is used to interact
  /// with the language check API.
  final LanguageCheckService baseService;

  /// A throttling used to throttle the API calls.
  final Throttling throttling;

  /// Creates a new instance of the [ThrottlingLangToolService] class.
  ThrottlingLangToolService(
    this.baseService,
    Duration throttlingDuration,
  ) : throttling = Throttling(duration: throttlingDuration);

  @override
  Future<Result<List<Mistake>>?> findMistakes(String text) async {
    final future = throttling.throttle(() => baseService.findMistakes(text))
        as Future<Result<List<Mistake>>?>?;

    if (future == null) return null;

    return future.then((res) => res ?? Result.success(<Mistake>[].toList()));
  }

  @override
  Future<void> dispose() async {
    throttling.close();
    await baseService.dispose();
  }
}
