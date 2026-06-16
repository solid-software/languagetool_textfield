import 'package:languagetool_textfield/languagetool_textfield.dart';

/// A [LanguageToolService] that post-filters mistakes reported by LanguageTool.
///
/// After delegating to [LanguageToolService.findMistakes], this service keeps
/// only mistakes that pass [_shouldIgnoreMistake]. A common use case is hiding
/// domain-specific vocabulary the user has marked as correct.
///
/// This class does not throttle or debounce requests. Wrap it in
/// [ThrottlingLanguageCheckService] or [DebounceLanguageCheckService] when
/// needed.
class InMemoryDictionaryLanguageCheckService extends LanguageCheckService {
  /// Predicate applied to each mistake returned by LanguageTool.
  ///
  /// Invoked once per [Mistake]. Mistakes for which this returns `true`
  /// are ignored and excluded from the final result.
  final bool Function(Mistake, String) _shouldIgnoreMistake;

  /// The underlying language check service that is used to find mistakes.
  final LanguageCheckService _languageCheckService;

  @override
  String get language => _languageCheckService.language;

  @override
  set language(String language) {
    _languageCheckService.language = language;
  }

  /// Creates an [InMemoryDictionaryLanguageCheckService].
  ///
  /// [shouldIgnoreMistake] is required and evaluated for every mistake returned
  /// by LanguageTool.
  /// An optional [languageCheckService] overrides the default service.
  InMemoryDictionaryLanguageCheckService({
    required bool Function(Mistake, String) shouldIgnoreMistake,
    LanguageCheckService? languageCheckService,
  })  : _shouldIgnoreMistake = shouldIgnoreMistake,
        _languageCheckService =
            languageCheckService ?? LanguageToolService(LanguageToolClient());

  @override
  Future<Result<List<Mistake>>?> findMistakes(String text) async {
    final result = await _languageCheckService.findMistakes(text);

    return result?.map(
      (mistakes) => mistakes
          .where((mistake) => !_shouldIgnoreMistake(mistake, text))
          .toList(growable: false),
    );
  }

  // ignore: proper_super_calls
  @override
  Future<void> dispose() async {
    await _languageCheckService.dispose();
    await super.dispose();
  }
}
