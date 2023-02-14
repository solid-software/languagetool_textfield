import 'package:languagetool_textfield/domain/model/mistake_type.dart';

class Mistake {
  final String message;
  final MistakeType type;
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

  int get start => offset;

  int get end => offset + length;
}
