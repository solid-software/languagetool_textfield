///Enumerate several mistake types
enum MistakeType {
  /// Misspelling mistake type
  misspelling,

  /// Typographical mistake type
  typographical,

  /// Grammar mistake type
  grammar,

  /// Uncategorized mistake type
  uncategorized,

  /// NonConformance mistake type
  nonConformance,

  /// Style mistake type
  style,

  /// Any other mistake type
  other;

  /// Getting the [MistakeType] from String.
  static MistakeType fromString(String value) {
    final lowercasedValue = value.toLowerCase();

    return MistakeType.values.firstWhere(
      (type) => type.toString().split('.').last == lowercasedValue,
      orElse: () => MistakeType.other,
    );
  }
}
