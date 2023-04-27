import 'dart:ui';

/// Class creates color scheme for highlighting mistakes
class HighlightColors {
  /// Misspelling mistake highlight color
  final Color? misspellingMistakeColor;

  /// Misspelling mistake highlight color
  final Color? typographicalMistakeColor;

  /// Typographical mistake highlight color
  final Color? grammarMistakeColor;

  /// Uncategorized mistake highlight color
  final Color? uncategorizedMistakeColor;

  /// NonConformance mistake highlight color
  final Color? nonConformanceMistakeColor;

  /// Style mistake highlight color
  final Color? styleMistakeColor;

  /// Other mistake highlight color
  final Color? otherMistakeColor;

  ///Color scheme constructor
  HighlightColors(
    this.misspellingMistakeColor,
    this.typographicalMistakeColor,
    this.grammarMistakeColor,
    this.uncategorizedMistakeColor,
    this.nonConformanceMistakeColor,
    this.styleMistakeColor,
    this.otherMistakeColor,
  );
}
