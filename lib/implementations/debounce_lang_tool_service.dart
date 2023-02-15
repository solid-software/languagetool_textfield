import 'package:languagetool_textfield/domain/api/language_check_service.dart';
import 'package:languagetool_textfield/domain/model/mistake.dart';
import 'package:throttling/throttling.dart';

/// Decorator for existing [LanguageCheckService].
/// Adds debounce between findMistakes() executing.
class DebounceLangToolService extends LanguageCheckService {
  final LanguageCheckService _baseService;
  final Debouncing _debouncing;

  /// Constructor
  DebounceLangToolService(
    this._baseService,
    Duration debouncingDuration,
  ) : _debouncing = Debouncing(duration: debouncingDuration);

  @override
  Future<List<Mistake>> findMistakes(String text) =>
      _debouncing.debounce(() => _baseService.findMistakes(text))
          as Future<List<Mistake>>;
}
