/// Category of the rule.
class Category {
  /// Id field.
  String id;

  /// Name field.
  String name;

  /// Constructor for [Category]
  Category({
    required this.id,
    required this.name,
  });

  /// Parse [Category] from json.
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        name: json['name'] as String,
      );

  /// Get json from [Category].
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
