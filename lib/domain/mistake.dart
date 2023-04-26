/// A data model class that stores information about a single writing mistake.
class Mistake {
  /// A brief description of the mistake.
  final String message;

  /// A type of this mistake.
  final String type;

  /// A position of the beginning of this mistake.
  final int offset;

  /// A length of this mistake after the offset.
  final int length;

  /// A list of suggestions for replacing this mistake.
  ///
  /// Sorted by probability.
  final List<String> replacements;

  /// A range of this mistake from offset to the end.
  int get range => offset + length;

  /// Creates a new instance of the [Mistake] class.
  const Mistake({
    required this.message,
    required this.type,
    required this.offset,
    required this.length,
    this.replacements = const [],
  });
}
