import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:languagetool_textfield/core/enums/mistake_type.dart';
import 'package:languagetool_textfield/domain/highlight_style.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/presentation/suggestions_popup.dart';

/// A TextEditingController with overrides buildTextSpan for building
/// marked TextSpans with tap recognizer
class ColoredTextEditingController extends TextEditingController {
  /// An [OverlayEntry] for the [Overlay] class.
  /// This entry represents the floating popup
  /// that appears on a mistake.
  OverlayEntry? _overlayEntry;

  /// Represents the maximum numbers of suggestions allowed.
  final int suggestionsLimit;

  static const int _defaultSuggestionLimit = 4;

  /// Color scheme to highlight mistakes
  final HighlightStyle highlightStyle;

  /// Language tool API index
  final LanguageCheckService languageCheckService;

  /// List which contains Mistake objects spans are built from
  List<Mistake> _mistakes = [];

  /// A builder function to build a custom mistake widget.
  /// If it is not provided then a default widget will be displayed.
  final Widget Function(
  String name,
  String message,
  Color color,
  List<String> replacements,
  Function(String) onSuggestionTap,
  Function() onClose,
  )? mistakeBuilder;

  @override
  set value(TextEditingValue newValue) {
    _handleTextChange(newValue.text);
    super.value = newValue;
  }

  /// Controller constructor
  ColoredTextEditingController({
    required this.languageCheckService,
    this.mistakeBuilder,
    this.highlightStyle = const HighlightStyle(),
    this.suggestionsLimit = _defaultSuggestionLimit,
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

    /// To remove the overlay when new text is entered in the field.
    _removeHighlightOverlay();
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

  Widget _widgetBuilder(
    String name,
    String message,
    Color color,
    List<String> replacements,
    void Function(String) onSuggestionTap,
    void Function() onClose,
  ) {
    return SuggestionsPopup(
      mistakeName: name,
      mistakeMessage: message,
      mistakeColor: color,
      replacements: replacements,
      onTapCallback: onSuggestionTap,
      closeCallBack: onClose,
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

      /// Number of suggestions depends on a limit.
      /// By default it is being set in _defaultSuggestionLimit
      final List<String> replacements =
          mistake.replacements.length <= suggestionsLimit
              ? mistake.replacements
              : mistake.replacements.sublist(0, suggestionsLimit);

      /// Parsing the mistake enum types to string type
      final String mistakeName = mistake.name;

      /// Mistake highlighted TextSpan
      yield TextSpan(
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTapDown = (TapDownDetails pressDetails) {
                /// getting the position of the user's finger
                final position = pressDetails.globalPosition;
                final screenWidth = MediaQuery.of(context).size.width;
                final containerWidth = screenWidth / 1.5;

                final newDx = _calculateDxOfPopup(
                  position.dx,
                  screenWidth,
                  containerWidth,
                );

                /// y axis of the popup widget.
                /// it will be slightly below the tapped area.
                final newDy = position.dy + 10;

                /// To remove overlay if present.
                _removeHighlightOverlay();

                final callback = mistakeBuilder ?? _widgetBuilder;

                final overlayEntry = OverlayEntry(
                  builder: (BuildContext context) {
                    return Positioned(
                      top: newDy,
                      left: newDx,
                      child: Material(
                        type: MaterialType.transparency,
                        child: SizedBox(
                          width: containerWidth,
                          child: callback(
                            mistakeName,
                            mistake.message,
                            mistakeColor,
                            replacements,
                            (newValue) {
                              text = text.replaceRange(
                                mistake.offset,
                                mistake.offset + mistake.length,
                                newValue,
                              );
                              _removeHighlightOverlay();
                            },
                            _removeHighlightOverlay,
                          ),
                        ),
                      ),
                    );
                  },
                );

                _overlayEntry = overlayEntry;
                Overlay.of(context).insert(overlayEntry);
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
    _overlayEntry?.remove();
    _overlayEntry = null;
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

  /// Calculates the new x axis for the popup so that it wont exceed the screen.
  double _calculateDxOfPopup(
    double dxOfTap,
    double screenWidth,
    double containerWidth,
  ) {
    /// The x axis point after which the popup exceeds the screen
    final dxBoundary = screenWidth - containerWidth;

    /// Calculating final x axis
    final newDx = dxOfTap >= dxBoundary ? dxBoundary : dxOfTap;

    return newDx;
  }
}
