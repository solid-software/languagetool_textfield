import 'package:languagetool_textfield/core/enums/mistake_type.dart';
import 'package:languagetool_textfield/core/model/category.dart';

/// Object that stores information about the rule (description, type, etc).
class Rule {
  /// Id (i.e.UPPERCASE_SENTENCE_START).
  final String id;

  /// The description in the set language.
  final String description;

  /// The type of the error (spelling, typographical, etc).
  final MistakeType issueType;

  /// The category of the rule.
  final Category category;

  /// The subscription status of the rule.
  final bool isPremium;

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
        issueType: MistakeType.fromString(json['issueType'] as String),
        category: Category.fromJson(json['category'] as Map<String, dynamic>),
        isPremium: json['isPremium'] as bool,
      );
}
