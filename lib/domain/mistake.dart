/// Object that stores information about a single writing mistake.
class Mistake {
  /// A brief description of the mistake.
  final String message;

  /// The type of mistake.
  final String type;

  /// Position of the beginning of the mistake.
  final int offset;

  /// Length of the mistake after the offset.
  final int length;

  /// A list of suggestions for replacing the mistake.
  ///
  /// Sorted by probability.
  final List<String> replacements;

  /// Object that stores information about a single writing mistake.
  const Mistake({
    required this.message,
    required this.type,
    required this.offset,
    required this.length,
    this.replacements = const [],
  });
}
