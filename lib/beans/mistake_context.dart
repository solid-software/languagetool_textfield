/// A data model class that stores context of the error,
/// i.e. the error and some text to the left and to the left.
class MistakeContext {
  /// Text.
  final String text;

  /// Offset to the text.
  final int offset;

  /// Length of the sentence.
  final int length;

  /// Creates a new instance of the [MistakeContext] class.
  MistakeContext({
    required this.text,
    required this.offset,
    required this.length,
  });

  /// Parse [MistakeContext] from json.
  factory MistakeContext.fromJson(Map<String, dynamic> json) => MistakeContext(
        text: json['text'] as String,
        offset: json['offset'] as int,
        length: json['length'] as int,
      );
}
