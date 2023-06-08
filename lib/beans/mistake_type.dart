/// Object that stores information about the type of the mistake.
class MistakeType {
  /// Indicates the mistake type (i.e. UnknownWord).
  final String typeName;

  /// Creates a new instance of the [MistakeType] class.
  MistakeType({
    required this.typeName,
  });

  /// Parse [MistakeType] from json.
  factory MistakeType.fromJson(Map<String, dynamic> json) => MistakeType(
        typeName: json['typeName'] as String,
      );

  /// Get json from [MistakeType].
  Map<String, dynamic> toJson() => {
        'typeName': typeName,
      };
}
