import 'package:languagetool_textfield/core/enums/mistake_type.dart';

/// A data model class that stores information about a single writing mistake.
class Mistake {
  /// A brief description of the mistake.
  final String message;

  /// A type of this mistake.
  final MistakeType type;

  /// A position of the beginning of this mistake.
  final int offset;

  /// A length of this mistake after the offset.
  final int length;

  /// A list of suggestions for replacing this mistake.
  ///
  /// Sorted by probability.
  final List<String> replacements;

  /// Name of the mistake in string form.
  /// The first letter will be capitalized
  String get name => type.name[0].toUpperCase() + type.name.substring(1);

  /// Creates a new instance of the [Mistake] class.
  const Mistake({
    required this.message,
    required this.type,
    required this.offset,
    required this.length,
    this.replacements = const [],
  });
}
