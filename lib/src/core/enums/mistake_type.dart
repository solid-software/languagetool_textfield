///Enumerate several mistake types
enum MistakeType {
  /// Misspelling mistake type
  misspelling('misspelling'),

  /// Typographical mistake type
  typographical('typographical'),

  /// Grammar mistake type
  grammar('grammar'),

  /// Uncategorized mistake type
  uncategorized('uncategorized'),

  /// NonConformance mistake type
  nonConformance('nonconformance'),

  /// Style mistake type
  style('style'),

  /// Any other mistake type
  other('other');

  /// The string value associated with the MistakeType variant
  final String value;

  const MistakeType(this.value);

  /// Getting the [MistakeType] from String.
  static MistakeType fromString(String value) {
    final lowercasedValue = value.toLowerCase();

    return MistakeType.values.firstWhere(
      (type) => type.value == lowercasedValue,
      orElse: () => MistakeType.other,
    );
  }
}
