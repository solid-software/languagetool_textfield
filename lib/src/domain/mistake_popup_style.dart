import 'package:flutter/material.dart';

/// Layout and styling options of the default mistake popup.
class MistakePopupStyle {
  static const double _defaultVerticalMargin = 25.0;
  static const double _defaultHorizontalMargin = 10.0;
  static const double _defaultMaxWidth = 250.0;

  /// A maximum width of the popup.
  /// If infinity, the popup will use all the available horizontal space.
  final double maxWidth;

  /// A maximum height of the popup.
  /// If infinity, the popup will use all the available height between the
  /// mistake position and the furthest border of the layout constraints.
  final double maxHeight;

  /// Horizontal popup margin.
  final double horizontalMargin;

  /// Vertical popup margin.
  final double verticalMargin;

  /// Style of the replacement suggestion buttons.
  final ButtonStyle? suggestionStyle;

  /// Creates a [MistakePopupStyle].
  const MistakePopupStyle({
    this.maxWidth = _defaultMaxWidth,
    this.maxHeight = double.infinity,
    this.horizontalMargin = _defaultHorizontalMargin,
    this.verticalMargin = _defaultVerticalMargin,
    this.suggestionStyle,
  });
}
