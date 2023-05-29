import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// A function that takes a json map and returns a value of type [T].
typedef JsonConverter<T> = T Function(dynamic json);

/// A base api request service.
/// Provides a [makeRequest] method to fetch a value of type [T] from the API.
///
/// The response body will be decoded from json and converted with the
/// [jsonConverter].
///
/// Http errors occurred during the request will be caught.
class ApiRequestService<T> {
  /// An API link.
  static const String apiLink = 'api.languagetoolplus.com';

  /// A [JsonConverter] to read the type [T] from a fetched json map.
  final JsonConverter<T> jsonConverter;

  // todo temporary until the Result wrapper is merged
  /// A value that will be returned instead of the result if an error has
  /// occurred during the fetch.
  final T orElse;

  /// Creates a new [ApiRequestService] with the provided [jsonConverter].
  const ApiRequestService(this.jsonConverter, this.orElse);

  // todo change it to return the Result wrapper when merged
  /// Sends the given [request] to the given [uri] and casts the result with
  /// the [jsonConverter].
  ///
  /// If an error has occurred during the request, the value of [orElse] will
  /// be returned.
  Future<T> makeRequest(Uri uri, http.BaseRequest request) async {
    final client = http.Client();
    Object? error;
    http.Response? response;

    try {
      response = await http.Response.fromStream(await client.send(request));
    } on http.ClientException catch (err) {
      error = err;
    }

    if (response?.statusCode != HttpStatus.ok) {
      error ??= http.ClientException(
        response?.reasonPhrase ?? 'Could not request',
        uri,
      );
    }

    if (error != null || response == null || response.bodyBytes.isEmpty) {
      return orElse;
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));

    return jsonConverter(decoded);
  }

  /// Makes a GET request to the [uri] with the given [headers] and casts the
  /// decoded result with the [jsonConverter].
  ///
  /// Catches the http errors during the request. If an error has occurred,
  /// returns the [orElse] value.
  Future<T> get(Uri uri, {Map<String, String> headers = const {}}) {
    final request = http.Request('GET', uri)..headers.addAll(headers);

    return makeRequest(uri, request);
  }

  /// Makes a POST request to the [uri] with the given [headers] and [body] and
  /// casts the decoded result with the [jsonConverter].
  ///
  /// Catches the http errors during the request. If an error has occurred,
  /// returns the [orElse] value.
  Future<T> post(
    Uri uri, {
    Map<String, String> headers = const {},
    Object? body,
  }) {
    final request = http.Request('POST', uri)..headers.addAll(headers);

    if (body != null) {
      request.bodyBytes = utf8.encode(jsonEncode(body));
    }

    return makeRequest(uri, request);
  }
}
