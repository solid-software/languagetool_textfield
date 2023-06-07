import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:languagetool_textfield/beans/language_tool_answer_raw.dart';
import 'package:languagetool_textfield/domain/writing_mistake.dart';

/// Class to interact with the LanguageTool API.
///
/// Read more @ https://languagetool.org/http-api/swagger-ui/#/
class LanguageTool {
  /// Url of LanguageTool API.
  static const _url = 'api.languagetoolplus.com';

  /// Headers for request.
  static const _headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
  };

  /// A language code.
  final String language;

  /// Constructor for [LanguageTool].
  LanguageTool({
    this.language = 'auto',
  });

  /// Checks the errors in text.
  Future<List<WritingMistake>> check(String text) => http
          .post(
        Uri.https(_url, 'v2/check'),
        headers: _headers,
        body: _getBodyForCheckRequest(text),
      )
          .then(
        (value) {
          final languageToolAnswer = LanguageToolAnswerRaw.fromJson(
            json.decode(utf8.decode(value.bodyBytes)) as Map<String, dynamic>,
          );

          return _parseRawAnswer(languageToolAnswer);
        },
      ).onError(
        (error, stackTrace) => throw Exception(error),
      );

  /// Converts a [LanguageToolAnswerRaw] in a [WritingMistake].
  List<WritingMistake> _parseRawAnswer(
    LanguageToolAnswerRaw languageToolAnswer,
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

  /// Get the body of the request.
  String _getBodyForCheckRequest(String uncheckedText) {
    final text = uncheckedText.replaceAll(' ', '%20');

    return 'text=$text&language=$language&enabledOnly=false&level=default';
  }
}
