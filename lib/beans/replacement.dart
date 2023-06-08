/// Possible replacement.
class Replacement {
  /// The replacement word.
  String value;

  /// Creates a new instance of the [Replacement] class.
  Replacement({
    required this.value,
  });

  /// Parse [Replacement] from json.
  factory Replacement.fromJson(Map<String, dynamic> json) => Replacement(
        value: json['value'] as String,
      );

  /// Get json from [Replacement].
  Map<String, dynamic> toJson() => {
        'value': value,
      };
}
