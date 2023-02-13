class Mistake {
  final String message;
  final String type;
  final int offset;
  final int length;
  final List<String> replacements;

  const Mistake({
    required this.message,
    required this.type,
    required this.offset,
    required this.length,
    this.replacements = const [],
  });
}
