/// Type of the mistake.
class Type {
  ///
  String typeName;

  ///
  Type({
    required this.typeName,
  });

  ///
  factory Type.fromJson(Map<String, dynamic> json) => Type(
        typeName: json['typeName'] as String,
      );

  ///
  Map<String, dynamic> toJson() => {
        'typeName': typeName,
      };
}
