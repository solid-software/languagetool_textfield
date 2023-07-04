/// Object that stores information about category of the rule.
class Category {
  /// Id field.
  final String id;

  /// Name field.
  final String name;

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
}
