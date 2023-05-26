import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:language_tool/language_tool.dart';
import 'package:languagetool_textfield/domain/language_fetch_service.dart';

/// A class that provide the functionality to fetch the supported language list
/// from the langtoolplus API and handles the errors occurred.
class LangFetchService implements LanguageFetchService {
  static const String _uri = 'api.languagetoolplus.com';
  static const String _path = 'v2/languages';
  static final Map<String, String> _headers = {
    HttpHeaders.acceptHeader: ContentType.json.value,
  };

  /// Creates a new [LangFetchService].
  const LangFetchService();

  // todo change to using ErrorWrapper when merged
  @override
  Future<List<Language>> fetchLanguages() async {
    final uri = Uri.https(_uri, _path);
    Object? error;

    http.Response? response;
    try {
      response = await http.get(uri, headers: _headers);
    } on http.ClientException catch (err) {
      error = err;
    }

    if (error == null && response?.statusCode != HttpStatus.ok) {
      error = http.ClientException(
        response?.reasonPhrase ?? 'Could not request',
        uri,
      );
    }

    if (response == null || response.bodyBytes.isEmpty) {
      return [];
    }

    final decoded =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

    return decoded.cast<Map<String, dynamic>>().map(Language.fromJson).toList();
  }
}
