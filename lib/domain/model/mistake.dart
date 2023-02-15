import 'package:languagetool_textfield/domain/model/mistake_type.dart';

/// Dataclass that stores info about mistake
class Mistake {
  /// Type of this mistake (grammar, style etc.)
  final MistakeType type;

  /// Description of current mistake
  final String description;

  /// Index of first mistake's character in text
  final int offset;

  /// Length of mistake in characters
  final int length;

  /// Suggested replacements for substring that has current mistake
  final List<String> replacements;

  /// Just another representation for index of
  /// the first character of mistake in text
  int get start => offset;

  /// Index of the last character of mistake in text
  int get end => offset + length;

  /// Constructor for this class
  const Mistake({
    required this.description,
    required this.type,
    required this.offset,
    required this.length,
    this.replacements = const [],
  });

}
