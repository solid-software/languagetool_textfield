import 'package:languagetool_textfield/src/core/model/match_location.dart';
import 'package:languagetool_textfield/src/core/model/replacement.dart';
import 'package:languagetool_textfield/src/core/model/rule.dart';

/// Object that stores information about matched mistakes.
class Match {
  /// The message about the error.
  final String message;

  /// Shortened message (may be empty).
  final String shortMessage;

  /// List of possible replacements
  final List<Replacement> replacements;

  /// Position of the mistake and the sentence containing it.
  final MatchLocation location;

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
    required this.location,
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
        location: MatchLocation.fromJson(json),
        rule: Rule.fromJson(json['rule'] as Map<String, dynamic>),
        ignoreForIncompleteSentence:
            json['ignoreForIncompleteSentence'] as bool,
        contextForSureMatch: json['contextForSureMatch'] as int,
      );
}
