import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/model/mistake.dart';
import 'package:languagetool_textfield/domain/model/mistake_type.dart';

class LanguageCheckController extends TextEditingController {
  final LayerLink _layerLink;
  final TextStyle Function(MistakeType?) _resolveStyle;
  final Widget Function(Mistake) _mistakeBuilder;

  OverlayEntry? _entry;
  List<Mistake> _mistakes;

  set mistakes(List<Mistake> value) {
    _mistakes = value;
    notifyListeners();
  }

  LanguageCheckController({
    required String text,
    required LayerLink layerLink,
    required TextStyle Function(MistakeType?) resolveStyle,
    required Widget Function(Mistake) mistakeBuilder,
    List<Mistake> mistakes = const [],
  })  : _layerLink = layerLink,
        _mistakeBuilder = mistakeBuilder,
        _resolveStyle = resolveStyle,
        _mistakes = mistakes,
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
        style: _resolveStyle(null),
      );
      yield TextSpan(
        text: text.substring(mistake.start, mistake.end),
        style: _resolveStyle(mistake.type),
        recognizer: TapGestureRecognizer()
          ..onTap = () => _showMistakeOverlay(context, mistake),
      );
      lastMistakeEnd = mistake.end;
    }
    yield TextSpan(
      text: text.substring(lastMistakeEnd),
      style: _resolveStyle(null),
    );
  }

  void _showMistakeOverlay(BuildContext context, Mistake mistake) {
    _hideLastOverlay();
    final entry = OverlayEntry(
      builder: (_) => CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        child: _mistakeBuilder(mistake),
      ),
    );

    _entry = entry;
    Overlay.of(context).insert(entry);
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
