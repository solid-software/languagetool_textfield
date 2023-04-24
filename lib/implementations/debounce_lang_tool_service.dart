import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:throttling/throttling.dart';

/// Implementation of language check service with debouncing.
class DebounceLangToolService extends LanguageCheckService {
  /// Base language check service.
  final LanguageCheckService baseService;

  /// Debouncing.
  final Debouncing debouncing;

  /// Implementation of language check service with debouncing.
  DebounceLangToolService(
    this.baseService,
    Duration debouncingDuration,
  ) : debouncing = Debouncing(duration: debouncingDuration);

  @override
  Future<List<Mistake>> findMistakes(String text) =>
      debouncing.debounce(() => baseService.findMistakes(text))
          as Future<List<Mistake>>;
}
