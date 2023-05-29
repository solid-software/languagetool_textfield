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

  factory MistakeType.fromSting(String issueType) {
    if (issueType == 'non-conformance') {
      return MistakeType.nonConformance;
    }

    return values.firstWhere(
      (e) => e.name == issueType,
      orElse: () => MistakeType.other,
    );
  }
}
