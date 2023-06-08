/// Category of the rule.
class Category {
  /// Id field.
  String id;

  /// Name field.
  String name;

  /// Creates a new instance of the [Category] class.
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
