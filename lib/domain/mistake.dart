import 'package:languagetool_textfield/core/dataclasses/mistake_match.dart';
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

  /// A position of the end of this mistake.
  int get endOffset => offset + length;

  /// Creates a new instance of the [Mistake] class.
  const Mistake({
    required this.message,
    required this.type,
    required this.offset,
    required this.length,
    this.replacements = const [],
  });

  /// Creates a new [Mistake] from the given [MistakeMatch] dataclass.
  factory Mistake.fromMatch(MistakeMatch match) => Mistake(
        message: match.message,
        type: MistakeType.fromSting(match.issueType),
        offset: match.offset,
        length: match.length,
        replacements: match.replacements.map((e) => e.value).toList(
              growable: false,
            ),
      );
}
