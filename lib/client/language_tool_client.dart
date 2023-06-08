import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:languagetool_textfield/beans/language_tool_raw.dart';
import 'package:languagetool_textfield/domain/writing_mistake.dart';

/// Class to interact with the LanguageTool API.
///
/// Read more @ https://languagetool.org/http-api/swagger-ui/#/
class LanguageToolClient {
  /// Url of LanguageTool API.
  static const _url = 'api.languagetoolplus.com';

  /// Headers for request.
  static const _headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
  };

  /// Constructor for [LanguageToolClient].
  LanguageToolClient();

  /// Checks the errors in text.
  Future<List<WritingMistake>> check(
    String text, {
    String language = 'auto',
  }) async {
    final result = await http.post(
      Uri.https(_url, 'v2/check'),
      headers: _headers,
      body: 'text=${text.replaceAll(' ', '%20')}&language=$language&'
          'enabledOnly=false&level=default',
    );

    final languageToolAnswer = LanguageToolRaw.fromJson(
      json.decode(utf8.decode(result.bodyBytes)) as Map<String, dynamic>,
    );

    return _parseRawAnswer(languageToolAnswer);
  }

  /// Converts a [LanguageToolRaw] in a [WritingMistake].
  List<WritingMistake> _parseRawAnswer(
    LanguageToolRaw languageToolAnswer,
  ) {
    final result = <WritingMistake>[];
    for (final match in languageToolAnswer.matches) {
      final replacements = <String>[];
      for (final item in match.replacements) {
        replacements.add(item.value);
      }

      result.add(
        WritingMistake(
          issueDescription: match.rule.description,
          issueType: match.rule.issueType,
          length: match.length,
          offset: match.offset,
          replacements: replacements,
          message: match.message,
          context: match.context,
          shortMessage: match.shortMessage,
        ),
      );
    }

    return result;
  }
}
