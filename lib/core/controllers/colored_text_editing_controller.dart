import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:languagetool_textfield/core/enums/mistake_type.dart';
import 'package:languagetool_textfield/domain/highlight_style.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

/// A TextEditingController with overrides buildTextSpan for building
/// marked TextSpans with tap recognizer
class ColoredTextEditingController extends TextEditingController {
  OverlayEntry? overlayEntry;

  /// Color scheme to highlight mistakes
  final HighlightStyle highlightStyle;

  /// Language tool API index
  final LanguageCheckService languageCheckService;

  /// List which contains Mistake objects spans are built from
  List<Mistake> _mistakes = [];

  @override
  set value(TextEditingValue newValue) {
    _handleTextChange(newValue.text);
    super.value = newValue;
  }

  /// Controller constructor
  ColoredTextEditingController({
    required this.languageCheckService,
    this.highlightStyle = const HighlightStyle(),
  });

  /// Clear mistakes list when text mas modified and get a new list of mistakes
  /// via API
  Future<void> _handleTextChange(String newText) async {
    ///set value triggers each time, even when cursor changes its location
    ///so this check avoid cleaning Mistake list when text wasn't really changed
    if (newText == text) return;
    _mistakes.clear();
    final mistakes = await languageCheckService.findMistakes(newText);
    if (mistakes.isNotEmpty) {
      _mistakes = mistakes;
      notifyListeners();
    }
  }

  /// Generates TextSpan from Mistake list
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final formattedTextSpans = _generateSpans(
      context: context,
      style: style,
    );

    return TextSpan(
      children: formattedTextSpans.toList(),
    );
  }

  /// Generator function to create TextSpan instances
  Iterable<TextSpan> _generateSpans({
    required BuildContext context,
    TextStyle? style,
  }) sync* {
    int currentOffset = 0; // enter index

    for (final Mistake mistake in _mistakes) {
      /// TextSpan before mistake
      yield TextSpan(
        text: text.substring(
          currentOffset,
          mistake.offset,
        ),
        style: style,
      );

      /// Get a highlight color
      final Color mistakeColor = _getMistakeColor(mistake.type);

      /// Mistake highlighted TextSpan
      yield TextSpan(
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTapDown = (TapDownDetails pressDetails) {
                final position = pressDetails.globalPosition;
                _removeHighlightOverlay();
                overlayEntry = OverlayEntry(
                  builder: (BuildContext context) {
                    return Positioned(
                    top: position.dy + 20,
                    left: position.dx,
                    child: Material(
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          width: 300.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: mistakeColor,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    mistake.type.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Text(mistake.message, softWrap: true,),
                              const SizedBox(height: 20.0),
                              Wrap(
                                children: mistake.replacements
                                    .map(
                                      (elem) => GestureDetector(
                                        onTap: () {
                                          text = text.replaceRange(
                                            mistake.offset,
                                            mistake.offset + mistake.length,
                                            elem,
                                          );
                                          _removeHighlightOverlay();
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            right: 5.0,
                                            bottom: 5.0,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: Colors.lightBlue,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            elem,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    );
                  },
                );

                Overlay.of(context).insert(overlayEntry!);
              },
            text:
                text.substring(mistake.offset, mistake.offset + mistake.length),
            mouseCursor: MaterialStateMouseCursor.clickable,
            style: style?.copyWith(
              backgroundColor: mistakeColor.withOpacity(
                highlightStyle.backgroundOpacity,
              ),
              decoration: highlightStyle.decoration,
              decorationColor: mistakeColor,
              decorationThickness: highlightStyle.mistakeLineThickness,
            ),
          ),
        ],
      );

      currentOffset = mistake.offset + mistake.length;
    }

    /// TextSpan after mistake
    yield TextSpan(
      text: text.substring(currentOffset),
      style: style,
    );
  }

  void _removeHighlightOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  /// Returns color for mistake TextSpan style
  Color _getMistakeColor(MistakeType type) {
    switch (type) {
      case MistakeType.misspelling:
        return highlightStyle.misspellingMistakeColor;
      case MistakeType.typographical:
        return highlightStyle.typographicalMistakeColor;
      case MistakeType.grammar:
        return highlightStyle.grammarMistakeColor;
      case MistakeType.uncategorized:
        return highlightStyle.uncategorizedMistakeColor;
      case MistakeType.nonConformance:
        return highlightStyle.nonConformanceMistakeColor;
      case MistakeType.style:
        return highlightStyle.styleMistakeColor;
      case MistakeType.other:
        return highlightStyle.otherMistakeColor;
    }
  }
}
