import 'package:languagetool_textfield/src/domain/language_check_service.dart';
import 'package:languagetool_textfield/src/domain/mistake.dart';
import 'package:languagetool_textfield/src/utils/result.dart';
import 'package:throttling/throttling.dart';

/// A language check service with debouncing.
class DebounceLangToolService extends LanguageCheckService {
  /// A base language check service.
  final LanguageCheckService baseService;

  /// A debouncing used to debounce the API calls.
  final Debouncing<Future<Result<List<Mistake>>?>> debouncing;

  @override
  String get language => baseService.language;

  @override
  set language(String language) {
    baseService.language = language;
  }

  /// Creates a new instance of the [DebounceLangToolService] class.
  DebounceLangToolService(
    this.baseService,
    Duration debouncingDuration,
  ) : debouncing = Debouncing(duration: debouncingDuration);

  @override
  Future<Result<List<Mistake>>?> findMistakes(String text) async =>
      await debouncing.debounce(() => baseService.findMistakes(text));

  // ignore: proper_super_calls
  @override
  Future<void> dispose() async {
    debouncing.close();
    await baseService.dispose();
  }
}
