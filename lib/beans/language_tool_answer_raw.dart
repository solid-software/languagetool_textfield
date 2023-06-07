import 'package:languagetool_textfield/languagetool_textfield.dart';

///
class LanguageToolAnswerRaw {
  ///
  List<Match> matches;

  ///
  Warnings warnings;

  ///
  LanguageToolAnswerRaw({
    required this.matches,
    required this.warnings,
  });

  ///
  factory LanguageToolAnswerRaw.fromJson(Map<String, dynamic> json) =>
      LanguageToolAnswerRaw(
        matches: (json['matches'] as Iterable)
            .map<Match>(
              (e) => Match.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        warnings: Warnings.fromJson(json['warnings'] as Map<String, dynamic>),
      );

  ///
  Map<String, dynamic> toJson() => {
        'matches': List<dynamic>.from(matches.map((x) => x.toJson())),
      };
}
