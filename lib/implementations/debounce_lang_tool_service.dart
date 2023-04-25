import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:throttling/throttling.dart';

/// A language check service with debouncing.
class DebounceLangToolService extends LanguageCheckService {
  /// A base language check service.
  final LanguageCheckService baseService;

  /// A debouncing used to debounce the API calls.
  final Debouncing debouncing;

  /// Creates a new instance of the [DebounceLangToolService] class.
  DebounceLangToolService(
    this.baseService,
    Duration debouncingDuration,
  ) : debouncing = Debouncing(duration: debouncingDuration);

  @override
  Future<List<Mistake>> findMistakes(String text) =>
      debouncing.debounce(() => baseService.findMistakes(text))
          as Future<List<Mistake>>;
}
