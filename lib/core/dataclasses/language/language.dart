/// A dataclass representing a language supported by the LanguageToolPlus API.
class Language {
  /// A human-readable name of this spell check language in English.
  final String name;

  /// A short language code of this language.
  final String code;

  /// Creates a new [Language] with the provided [name] and [code].
  const Language({required this.name, required this.code});

  /// Reads a [Language] from the given [json].
  factory Language.fromJson(Map<String, dynamic> json) => Language(
        name: json['name'] as String,
        code: json['code'] as String,
      );

  /// Creates a Map<String, dynamic> json from this [Language].
  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
      };
}
