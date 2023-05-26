import 'dart:async';

import 'package:language_tool/language_tool.dart';
import 'package:languagetool_textfield/domain/language_fetch_service.dart';

/// A caching decorator for [LanguageFetchService] to not fetch the languages
/// twice.
class CachingLangFetchService implements LanguageFetchService {
  static final List<Language> _cachedLanguages = [];

  /// A wrapped [LanguageFetchService]. If there is no cache saved, its
  /// [LanguageFetchService.fetchLanguages] method will be used to create it.
  final LanguageFetchService baseService;

  /// Creates a new [CachingLangFetchService] with the given [baseService].
  const CachingLangFetchService(this.baseService);

  @override
  Future<List<Language>> fetchLanguages() async {
    if (_cachedLanguages.isEmpty) {
      _cachedLanguages.addAll(await baseService.fetchLanguages());
    }

    return _cachedLanguages;
  }
}