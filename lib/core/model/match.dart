import 'package:languagetool_textfield/core/model/replacement.dart';
import 'package:languagetool_textfield/core/model/rule.dart';

/// Object that stores information about matched mistakes.
class Match {
  /// The message about the error.
  final String message;

  /// Shortened message (may be empty).
  final String shortMessage;

  /// List of possible replacements
  final List<Replacement> replacements;

  /// Offset to the word.
  final int offset;

  /// Length of the word.
  final int length;

  /// The whole sentence.
  final String sentence;

  /// The mistake's rule.
  final Rule rule;

  /// Flag that indicates if the mistake is because sentence is incomplete.
  final bool ignoreForIncompleteSentence;

  /// Context for sure match (i.e. -1, 0, 1, etc).
  final int contextForSureMatch;

  /// Creates a new instance of the [Match] class.
  Match({
    required this.message,
    required this.shortMessage,
    required this.replacements,
    required this.offset,
    required this.length,
    required this.sentence,
    required this.rule,
    required this.ignoreForIncompleteSentence,
    required this.contextForSureMatch,
  });

  /// Parse [Match] from json.
  factory Match.fromJson(Map<String, dynamic> json) => Match(
        message: json['message'] as String,
        shortMessage: json['shortMessage'] as String,
        replacements: (json['replacements'] as Iterable)
            .map<Replacement>(
              (e) => Replacement.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        offset: json['offset'] as int,
        length: json['length'] as int,
        sentence: json['sentence'] as String,
        rule: Rule.fromJson(json['rule'] as Map<String, dynamic>),
        ignoreForIncompleteSentence:
            json['ignoreForIncompleteSentence'] as bool,
        contextForSureMatch: json['contextForSureMatch'] as int,
      );
}
