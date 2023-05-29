import 'package:languagetool_textfield/core/dataclasses/language/language.dart';

/// A dataclass representing a supported language returned from the 'languages'
/// API endpoint.
class SupportedLanguage extends Language {
  /// A long code of this language.
  final String longCode;

  /// Creates a new [SupportedLanguage] with the provided [name], [code], and
  /// [longCode].
  const SupportedLanguage({
    required super.name,
    required super.code,
    required this.longCode,
  });

  /// Reads a [SupportedLanguage] from the given [json].
  factory SupportedLanguage.fromJson(Map<String, dynamic> json) {
    final detectedLanguage = Language.fromJson(json);

    return SupportedLanguage(
      name: detectedLanguage.name,
      code: detectedLanguage.code,
      longCode: json['longCode'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'longCode': longCode,
      };
}
