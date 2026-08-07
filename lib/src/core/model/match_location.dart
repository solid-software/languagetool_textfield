/// Where a match occurred: its position within the checked text
/// and the sentence containing it.
class MatchLocation {
  /// Offset to the word.
  final int offset;

  /// Length of the word.
  final int length;

  /// The whole sentence.
  final String sentence;

  /// Creates a new instance of the [MatchLocation] class.
  const MatchLocation({
    required this.offset,
    required this.length,
    required this.sentence,
  });

  /// Parse [MatchLocation] from the json of the match it belongs to.
  factory MatchLocation.fromJson(Map<String, dynamic> json) => MatchLocation(
        offset: json['offset'] as int,
        length: json['length'] as int,
        sentence: json['sentence'] as String,
      );
}
