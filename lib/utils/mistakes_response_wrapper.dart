import 'package:language_tool/language_tool.dart';

/// A wrapper class wrapping a list of mistakes found by the API
/// alongside the response status and error.
class MistakesResponseWrapper {
  /// The [WritingMistake] list which was received from the API.
  /// If the error has occurred, it will be empty.
  final List<WritingMistake> mistakes;

  /// The error which may have occurred during the API request.
  /// If the request was successful, it will ne null.
  final Object? error;

  /// Returns true if no error has occurred during the API request.
  bool get hasResult => error == null;

  /// Creates a new success [MistakesResponseWrapper] with the given [mistakes]
  /// list.
  const MistakesResponseWrapper.success(this.mistakes) : error = null;

  /// Creates a new error [MistakesResponseWrapper] with the given error.
  const MistakesResponseWrapper.error(Object this.error) : mistakes = const [];
}
