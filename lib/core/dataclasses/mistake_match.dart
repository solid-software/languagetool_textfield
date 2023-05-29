import 'package:languagetool_textfield/core/dataclasses/mistake_replacement.dart';

/// A dataclass representing a single matched mistake returned from the API.
class MistakeMatch {
  /// A human-readable message describing mistake.
  final String message;

  /// A shorter message describing this mistake.
  /// Can be empty.
  final String shortMessage;

  /// An offset of this mistake in the checked text.
  final int offset;

  /// A length of this mistake match.
  final int length;

  /// A complete sentence containing this mistake.
  final String sentence;

  /// A list of suggested replacements for this mistake.
  final List<MistakeReplacement> replacements;

  /// A type of the rule applied to this mistake.
  final String issueType;

  /// Creates a new [MistakeMatch] with the provided parameters.
  const MistakeMatch({
    required this.message,
    required this.shortMessage,
    required this.offset,
    required this.length,
    required this.sentence,
    required this.replacements,
    required this.issueType,
  });

  /// Reads a [MistakeMatch] from the given [json].
  factory MistakeMatch.fromJson(Map<String, dynamic> json) {
    final replacementsJson = json['replacements'] as List<dynamic>;
    final ruleJson = json['rule'] as Map<String, dynamic>;
    final replacements = replacementsJson
        .cast<Map<String, dynamic>>()
        .map(
          MistakeReplacement.fromJson,
        )
        .toList(growable: false);

    return MistakeMatch(
      message: json['message'] as String,
      shortMessage: json['shortMessage'] as String,
      offset: json['offset'] as int,
      length: json['length'] as int,
      sentence: json['sentence'] as String,
      replacements: replacements,
      issueType: ruleJson['issueType'] as String,
    );
  }

  /// Creates a Map<String, dynamic> json from this [MistakeMatch].
  Map<String, dynamic> toJson() => {
        'message': message,
        'shortMessage': shortMessage,
        'offset': offset,
        'length': length,
        'sentence': sentence,
        'replacements': replacements.map((e) => e.toJson()).toList(
              growable: false,
            ),
        'issueType': issueType,
      };
}
