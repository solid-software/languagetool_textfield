import 'package:flutter/material.dart';

/// Class creates color scheme for highlighting mistakes
class HighlightStyle {
  ///Initial values
  static const double _initialBackgroundOpacity = 0.2;
  static const double _initialLineHeight = 1.5;

  /// Misspelling mistake highlight color
  final Color misspellingMistakeColor;

  /// Misspelling mistake highlight color
  final Color typographicalMistakeColor;

  /// Typographical mistake highlight color
  final Color grammarMistakeColor;

  /// Uncategorized mistake highlight color
  final Color uncategorizedMistakeColor;

  /// NonConformance mistake highlight color
  final Color nonConformanceMistakeColor;

  /// Style mistake highlight color
  final Color styleMistakeColor;

  /// Other mistake highlight color
  final Color otherMistakeColor;

  /// background opacity for mistake TextSpan
  final double backgroundOpacity;

  /// mistake TextSpan underline thickness
  final double mistakeLineThickness;

  /// Mistaken text decoration style
  final TextDecoration decoration;

  ///Color scheme constructor
  const HighlightStyle({
    this.misspellingMistakeColor = Colors.red,
    this.typographicalMistakeColor = Colors.green,
    this.grammarMistakeColor = Colors.amber,
    this.uncategorizedMistakeColor = Colors.blue,
    this.nonConformanceMistakeColor = Colors.greenAccent,
    this.styleMistakeColor = Colors.deepPurpleAccent,
    this.otherMistakeColor = Colors.white60,
    this.backgroundOpacity = _initialBackgroundOpacity,
    this.mistakeLineThickness = _initialLineHeight,
    this.decoration = TextDecoration.underline,
  });
}
