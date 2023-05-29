import 'dart:io';

import 'package:languagetool_textfield/core/dataclasses/language/supported_language.dart';
import 'package:languagetool_textfield/domain/api_request_service.dart';
import 'package:languagetool_textfield/domain/language_fetch_service.dart';

/// A class that provide the functionality to fetch the supported language list
/// from the langtoolplus API and handles the errors occurred.
class LangFetchService implements LanguageFetchService {
  static const String _path = 'v2/languages';
  static final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: ContentType.json.value,
  };

  final ApiRequestService<List<SupportedLanguage>> _fetchService;

  /// Creates a new [LangFetchService].
  const LangFetchService([
    this._fetchService =
        const ApiRequestService(_languagesResponseConverter, []),
  ]);

  @override
  Future<List<SupportedLanguage>> fetchLanguages() async {
    final uri = Uri.https(ApiRequestService.apiLink, _path);

    return _fetchService.get(uri, headers: _headers);
  }
}

List<SupportedLanguage> _languagesResponseConverter(dynamic json) {
  final list = json as List<dynamic>;

  return list
      .cast<Map<String, dynamic>>()
      .map(SupportedLanguage.fromJson)
      .toList(growable: false);
}
