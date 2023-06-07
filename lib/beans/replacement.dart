/// Possible replacement.
class Replacement {
  ///
  String value;

  ///
  Replacement({
    required this.value,
  });

  ///
  factory Replacement.fromJson(Map<String, dynamic> json) => Replacement(
        value: json['value'] as String,
      );

  ///
  Map<String, dynamic> toJson() => {
        'value': value,
      };
}
