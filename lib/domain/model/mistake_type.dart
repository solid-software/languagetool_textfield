/// Represents types of mistakes which this library can recognize
enum MistakeType {
  /// Unknown mistake. Mistakes marked with this value are not supported yet
  unknown,

  /// Typographical mistake
  typographical,

  /// Grammar mistake
  grammar,

  /// Style mistake
  style,
}
