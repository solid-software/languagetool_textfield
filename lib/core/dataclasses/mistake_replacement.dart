/// A dataclass representing a single mistake replacement suggestion.
class MistakeReplacement {
  /// A value of this [MistakeReplacement] suggestion.
  final String value;

  /// Creates a new [MistakeReplacement] with the provided [value].
  const MistakeReplacement({required this.value});

  /// Reads a [MistakeReplacement] from the given [json].
  factory MistakeReplacement.fromJson(Map<String, dynamic> json) =>
      MistakeReplacement(value: json['value'] as String);

  /// Creates a Map<String, dynamic> json from this [MistakeReplacement].
  Map<String, dynamic> toJson() => {
        'value': value,
      };
}
