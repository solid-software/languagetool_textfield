/// Object that stores information about possible replacement.
class Replacement {
  /// The replacement word.
  final String value;

  /// Creates a new instance of the [Replacement] class.
  Replacement({
    required this.value,
  });

  /// Parse [Replacement] from json.
  factory Replacement.fromJson(Map<String, dynamic> json) => Replacement(
        value: json['value'] as String,
      );
}
