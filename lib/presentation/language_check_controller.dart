import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/model/mistake.dart';
import 'package:languagetool_textfield/domain/model/mistake_type.dart';

class LanguageCheckController extends TextEditingController {
  final LayerLink layerLink;
  final TextStyle Function(MistakeType?) resolveStyle;
  final Widget Function(Mistake) mistakeBuilder;

  OverlayEntry? _entry;
  List<Mistake> _mistakes;

  set mistakes(List<Mistake> value) {
    _mistakes = value;
    notifyListeners();
  }

  LanguageCheckController({
    required String text,
    required this.layerLink,
    required this.mistakeBuilder,
    required this.resolveStyle,
    List<Mistake> mistakes = const [],
  })  : _mistakes = mistakes,
        super(text: text);

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
    _hideLastOverlay();
    _entry = OverlayEntry(
      builder: (_) => CompositedTransformFollower(
        link: layerLink,
        showWhenUnlinked: false,
        child: mistakeBuilder(mistake),
      ),
    );

    final entry = _entry;
    if (entry != null) {
      Overlay.of(context).insert(entry);
    }
  }

  void _hideLastOverlay() {
    _entry?.remove();
    _entry?.dispose();
  }

  @override
  void dispose() {
    _hideLastOverlay();
    super.dispose();
  }
}
