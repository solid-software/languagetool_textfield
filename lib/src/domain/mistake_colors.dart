import 'package:flutter/material.dart';
import 'package:languagetool_textfield/src/core/enums/mistake_type.dart';

/// Highlight colors of the text field, one per [MistakeType].
class MistakeColors {
  /// Misspelling mistake highlight color
  final Color misspelling;

  /// Typographical mistake highlight color
  final Color typographical;

  /// Grammar mistake highlight color
  final Color grammar;

  /// Uncategorized mistake highlight color
  final Color uncategorized;

  /// NonConformance mistake highlight color
  final Color nonConformance;

  /// Style mistake highlight color
  final Color style;

  /// Any other mistake highlight color
  final Color other;

  /// Creates a set of mistake highlight colors.
  const MistakeColors({
    this.misspelling = Colors.red,
    this.typographical = Colors.green,
    this.grammar = Colors.amber,
    this.uncategorized = Colors.blue,
    this.nonConformance = Colors.greenAccent,
    this.style = Colors.deepPurpleAccent,
    this.other = Colors.white60,
  });

  /// Returns the highlight color of a mistake of the given [type].
  Color colorOf(MistakeType type) => switch (type) {
        MistakeType.misspelling => misspelling,
        MistakeType.typographical => typographical,
        MistakeType.grammar => grammar,
        MistakeType.uncategorized => uncategorized,
        MistakeType.nonConformance => nonConformance,
        MistakeType.style => style,
        MistakeType.other => other,
      };
}
