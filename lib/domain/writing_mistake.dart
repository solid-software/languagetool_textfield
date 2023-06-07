import 'package:languagetool_textfield/beans/context.dart';

/// Object that stores information about a single writing mistake.
class WritingMistake {
  /// Position of the beginning of the mistake.
  final int offset;

  /// Length of the mistake after the offset.
  final int length;

  /// The type of mistake.
  final String issueType;

  /// Description of the [issueType].
  final String issueDescription;

  /// A brief description of the mistake.
  final String message;

  /// A list of suggestions for replacing the mistake.
  ///
  /// Sorted by probability.
  final List<String> replacements;

  /// An optional shorter version of 'message'. ,
  final String shortMessage;

  /// Context of the error,
  /// i.e. the error and some text to the left and to the left.
  final Context context;

  /// Object that stores information about a single writing mistake.
  WritingMistake({
    required this.message,
    required this.offset,
    required this.length,
    required this.issueType,
    required this.issueDescription,
    required this.replacements,
    required this.shortMessage,
    required this.context,
  });

  /// Copies the object with the specified values changed.
  WritingMistake copyWith({
    required int offset,
    required int length,
    required String issueType,
    required String issueDescription,
    required String message,
    required List<String> replacements,
    required String shortMessage,
    required Context context,
  }) {
    return WritingMistake(
      offset: offset,
      length: length,
      issueType: issueType,
      issueDescription: issueDescription,
      message: message,
      replacements: replacements,
      context: context,
      shortMessage: shortMessage,
    );
  }
}
