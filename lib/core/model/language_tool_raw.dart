import 'package:languagetool_textfield/languagetool_textfield.dart';

/// The raw bean that is returned from the API call.
///
/// It's possible to add software, language and warning information.
class LanguageToolRaw {
  /// The matched mistakes.
  final List<Match> matches;

  /// Creates a new instance of the [LanguageToolRaw] class.
  LanguageToolRaw({
    required this.matches,
  });

  /// Parse [LanguageToolRaw] from json.
  factory LanguageToolRaw.fromJson(Map<String, dynamic> json) =>
      LanguageToolRaw(
        matches: (json['matches'] as Iterable)
            .map<Match>(
              (e) => Match.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
}
