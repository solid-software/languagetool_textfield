/// Object that stores information about the type of the mistake.
class Type {
  /// Indicates the mistake type (i.e. UnknownWord).
  final String typeName;

  /// Creates a new instance of the [Type] class.
  Type({
    required this.typeName,
  });

  /// Parse [Type] from json.
  factory Type.fromJson(Map<String, dynamic> json) => Type(
        typeName: json['typeName'] as String,
      );

  /// Get json from [Type].
  Map<String, dynamic> toJson() => {
        'typeName': typeName,
      };
}
