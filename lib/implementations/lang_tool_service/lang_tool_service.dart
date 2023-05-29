import 'dart:io';

import 'package:languagetool_textfield/core/dataclasses/mistake_match.dart';
import 'package:languagetool_textfield/domain/api_request_service.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

/// A basic implementation of a [LanguageCheckService].
class LangToolService extends LanguageCheckService {
  static const String _path = 'v2/check';
  static final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: ContentType.json.value,
    HttpHeaders.contentTypeHeader:
        ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8')
            .value,
  };

  final ApiRequestService<List<MistakeMatch>> _fetchService;

  /// Creates a new instance of the [LangToolService].
  const LangToolService([
    this._fetchService =
        const ApiRequestService(_mistakesResponseConverter, []),
  ]);

  @override
  Future<List<Mistake>> findMistakes(
    String text, {
    String checkLanguage = 'auto',
    bool isPicky = false,
  }) async {
    final uri = Uri.https(
      ApiRequestService.apiLink,
      _path,
    );

    final body = _encodeFormData(
      text,
      language: checkLanguage,
      isPicky: isPicky,
    );

    final writingMistakes = await _fetchService.post(
      uri,
      headers: _headers,
      body: body,
    );

    final mistakes = writingMistakes.map(Mistake.fromMatch);

    return mistakes.toList();
  }

  String _encodeFormData(
    String text, {
    required String language,
    required bool isPicky,
  }) {
    final escapedText = Uri.encodeFull(text);
    final formData = '&language=$language'
        '&enabledOnly=false'
        '&level=${isPicky ? 'picky' : 'default'}'
        '&text=$escapedText';

    return formData;
  }
}

/// expected json structure:
/// ```json
/// {
///   ...
///   matches: [
///     {MistakeMatch},
///     {MistakeMatch},
///     ...
///   ]
///   ...
/// }
/// ```
List<MistakeMatch> _mistakesResponseConverter(dynamic json) {
  final checkJson = json as Map<String, dynamic>;
  final matchesJson = checkJson['matches'] as List<dynamic>;

  return matchesJson
      .cast<Map<String, dynamic>>()
      .map(MistakeMatch.fromJson)
      .toList(growable: false);
}
