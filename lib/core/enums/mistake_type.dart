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
    switch (value.toLowerCase()) {
      case 'misspelling':
        return MistakeType.misspelling;
      case 'typographical':
        return MistakeType.typographical;
      case 'grammar':
        return MistakeType.grammar;
      case 'uncategorized':
        return MistakeType.uncategorized;
      case 'non-conformance':
        return MistakeType.nonConformance;
      case 'style':
        return MistakeType.style;
      default:
        return MistakeType.other;
    }
  }
}
