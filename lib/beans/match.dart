import 'package:languagetool_textfield/beans/context.dart';
import 'package:languagetool_textfield/beans/replacement.dart';
import 'package:languagetool_textfield/beans/rule.dart';
import 'package:languagetool_textfield/beans/type.dart';

///
class Match {
  ///
  String message;

  /// Shortened message (may be empty).
  String shortMessage;

  /// List of possible replacements
  List<Replacement> replacements;

  ///
  int offset;

  ///
  int length;

  ///
  Context context;

  ///
  String sentence;

  ///
  Type type;

  ///
  Rule rule;

  ///
  bool ignoreForIncompleteSentence;

  ///
  int contextForSureMatch;

  ///
  Match({
    required this.message,
    required this.shortMessage,
    required this.replacements,
    required this.offset,
    required this.length,
    required this.context,
    required this.sentence,
    required this.type,
    required this.rule,
    required this.ignoreForIncompleteSentence,
    required this.contextForSureMatch,
  });

  ///
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
        context: Context.fromJson(json['context'] as Map<String, dynamic>),
        sentence: json['sentence'] as String,
        type: Type.fromJson(json['type'] as Map<String, dynamic>),
        rule: Rule.fromJson(json['rule'] as Map<String, dynamic>),
        ignoreForIncompleteSentence:
            json['ignoreForIncompleteSentence'] as bool,
        contextForSureMatch: json['contextForSureMatch'] as int,
      );

  ///
  Map<String, dynamic> toJson() => {
        'message': message,
        'shortMessage': shortMessage,
        'replacements': List<dynamic>.from(replacements.map((x) => x.toJson())),
        'offset': offset,
        'length': length,
        'context': context.toJson(),
        'sentence': sentence,
        'type': type.toJson(),
        'rule': rule.toJson(),
        'ignoreForIncompleteSentence': ignoreForIncompleteSentence,
        'contextForSureMatch': contextForSureMatch,
      };
}
