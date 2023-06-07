/// Context of the error,
/// i.e. the error and some text to the left and to the left.
class Context {
  /// Text.
  String text;

  /// Offset to the text.
  int offset;

  /// Length of the sentence.
  int length;

  ///
  Context({
    required this.text,
    required this.offset,
    required this.length,
  });

  ///
  factory Context.fromJson(Map<String, dynamic> json) => Context(
        text: json['text'] as String,
        offset: json['offset'] as int,
        length: json['length'] as int,
      );

  ///
  Map<String, dynamic> toJson() => {
        'text': text,
        'offset': offset,
        'length': length,
      };
}
