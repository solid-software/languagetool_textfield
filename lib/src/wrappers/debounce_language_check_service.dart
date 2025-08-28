import 'package:languagetool_textfield/src/domain/language_check_service.dart';
import 'package:languagetool_textfield/src/domain/mistake.dart';
import 'package:languagetool_textfield/src/utils/result.dart';
import 'package:throttling/throttling.dart';

/// A language check service with debouncing.
class DebounceLanguageCheckService extends LanguageCheckService {
  /// A base language check service.
  final LanguageCheckService _languageCheckService;

  /// A debouncing used to debounce the API calls.
  final Debouncing<Future<Result<List<Mistake>>?>> _debouncing;

  @override
  String get language => _languageCheckService.language;

  @override
  set language(String language) {
    _languageCheckService.language = language;
  }

  /// Creates a new instance of the [DebounceLanguageCheckService] class.
  DebounceLanguageCheckService(
    this._languageCheckService,
    Duration debouncingDuration,
  ) : _debouncing = Debouncing(duration: debouncingDuration);

  @override
  Future<Result<List<Mistake>>?> findMistakes(String text) async {
    return await _debouncing
        .debounce(() => _languageCheckService.findMistakes(text));
  }

  // ignore: proper_super_calls
  @override
  Future<void> dispose() async {
    _debouncing.close();
    await _languageCheckService.dispose();
  }
}
