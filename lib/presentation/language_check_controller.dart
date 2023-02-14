import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/api/language_check_service.dart';
import 'package:languagetool_textfield/domain/model/mistake.dart';

class LanguageCheckController extends TextEditingController {
  List<Mistake> _mistakes = [];

  final LanguageCheckService service;
  final TextStyle Function(Mistake?) resolveStyle;

  LanguageCheckController({
    required String text,
    required this.service,
    required this.resolveStyle,
  }) : super(text: text);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) =>
      _mistakes.isEmpty
          ? TextSpan(text: text)
          : TextSpan(children: _buildTextWithMistakes().toList());

  Iterable<TextSpan> _buildTextWithMistakes() sync* {
    var lastMistakeEnd = 0;
    for (final mistake in _mistakes) {
      yield TextSpan(
        text: text.substring(lastMistakeEnd, mistake.start),
        style: resolveStyle(null),
      );
      yield TextSpan(
        text: text.substring(mistake.start, mistake.end),
        style: resolveStyle(mistake),
      );
      lastMistakeEnd = mistake.end;
    }
    yield TextSpan(
      text: text.substring(lastMistakeEnd),
      style: resolveStyle(null),
    );
  }

  Future<void> validate() async {
    _mistakes = await service.findMistakes(text);
    notifyListeners();
  }
}
