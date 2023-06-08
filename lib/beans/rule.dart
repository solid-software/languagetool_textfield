import 'package:languagetool_textfield/beans/category.dart';

/// The rule description.
class Rule {
  /// Id (i.e.UPPERCASE_SENTENCE_START).
  String id;

  /// The description in the set language.
  String description;

  /// The type of the error (spelling, typographical, etc).
  String issueType;

  /// The category of the rule.
  Category category;

  /// The subscription status of the rule.
  bool isPremium;

  /// Creates a new instance of the [Rule] class.
  Rule({
    required this.id,
    required this.description,
    required this.issueType,
    required this.category,
    required this.isPremium,
  });

  /// Parse [Rule] from json.
  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
        id: json['id'] as String,
        description: json['description'] as String,
        issueType: json['issueType'] as String,
        category: Category.fromJson(json['category'] as Map<String, dynamic>),
        isPremium: json['isPremium'] as bool,
      );

  /// Get json from [Rule].
  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'issueType': issueType,
        'category': category.toJson(),
        'isPremium': isPremium,
      };
}
