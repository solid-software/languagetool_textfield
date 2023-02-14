import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/api/language_check_service.dart';
import 'package:languagetool_textfield/domain/model/mistake.dart';
import 'package:languagetool_textfield/domain/model/mistake_type.dart';

class LanguageCheckController extends TextEditingController {
  List<Mistake> _mistakes = [];

  final LayerLink layerLink;
  final LanguageCheckService service;
  final TextStyle Function(MistakeType?) resolveStyle;
  final Widget Function(Mistake) mistakeBuilder;

  LanguageCheckController({
    required String text,
    required this.layerLink,
    required this.service,
    required this.mistakeBuilder,
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
          : TextSpan(children: _buildTextWithMistakes(context).toList());

  Iterable<InlineSpan> _buildTextWithMistakes(BuildContext context) sync* {
    var lastMistakeEnd = 0;
    for (final mistake in _mistakes) {
      yield TextSpan(
        text: text.substring(lastMistakeEnd, mistake.start),
        style: resolveStyle(null),
      );
      yield TextSpan(
        text: text.substring(mistake.start, mistake.end),
        style: resolveStyle(mistake.type),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _showMistakeOverlay(context, mistake),
      );
      lastMistakeEnd = mistake.end;
    }
    yield TextSpan(
      text: text.substring(lastMistakeEnd),
      style: resolveStyle(null),
    );
  }

  void _showMistakeOverlay(BuildContext context, Mistake mistake) {
    final entry = OverlayEntry(
      builder: (_) => CompositedTransformFollower(
        link: layerLink,
        showWhenUnlinked: false,
        child: mistakeBuilder(mistake),
      ),
    );

    Overlay.of(context).insert(entry);
  }

  Future<void> validate() async {
    _mistakes = await service.findMistakes(text);
    notifyListeners();
  }
}
