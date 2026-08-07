import 'package:flutter/material.dart';
import 'package:languagetool_textfield/src/domain/mistake_colors.dart';

/// Class creates color scheme for highlighting mistakes
class HighlightStyle {
  ///Initial values
  static const double _initialBackgroundOpacity = 0.2;
  static const double _initialLineHeight = 1.5;

  /// Highlight color of each mistake type
  final MistakeColors colors;

  /// background opacity for mistake TextSpan
  final double backgroundOpacity;

  /// mistake TextSpan underline thickness
  final double mistakeLineThickness;

  /// Mistaken text decoration style
  final TextDecoration decoration;

  /// Color scheme constructor
  const HighlightStyle({
    this.colors = const MistakeColors(),
    this.backgroundOpacity = _initialBackgroundOpacity,
    this.mistakeLineThickness = _initialLineHeight,
    this.decoration = TextDecoration.underline,
  });
}
