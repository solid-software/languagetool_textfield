import 'dart:math';

import 'package:flutter/material.dart';

///
const defaultPopupWidth = 250.0;

/// Renderer used to show popup window overlay
class PopupOverlayRenderer {
  OverlayEntry? _overlayEntry;

  /// Max width of popup window
  final double maxWidth;

  /// [PopupOverlayRenderer] constructor
  PopupOverlayRenderer({this.maxWidth = defaultPopupWidth});

  /// Render overlay entry on the screen with dismiss logic
  OverlayEntry render(
    BuildContext context, {
    required Offset position,
    required WidgetBuilder popupBuilder,
  }) {
    // final Offset _popupPosition = _calculatePosition(context, position);

    final _createdEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: dismiss,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                child: CustomSingleChildLayout(
                  delegate: PopupOverlayLayoutDelegate(maxWidth, position),
                  child: popupBuilder(context),
                ),
              )
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_createdEntry);
    _overlayEntry = _createdEntry;

    return _createdEntry;
  }

  /// Remove popup
  void dismiss() {
    _overlayEntry?.remove();
  }
}

/// Class that calculates where to place popup window on the screen
class PopupOverlayLayoutDelegate extends SingleChildLayoutDelegate {
  /// max width of popup window
  final double maxWidth;

  /// desired position of popup window
  final Offset position;

  /// [PopupOverlayLayoutDelegate] constructor
  const PopupOverlayLayoutDelegate(this.maxWidth, this.position);

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return _calculatePosition(size, position, childSize);
  }

  Offset _calculatePosition(Size size, Offset position, Size childSize) {
    final _popupRect = Rect.fromCenter(
      center: position,
      width: childSize.width,
      height: childSize.height,
    );
    const _screenBorderPadding = 10.0;
    print("size: $size");

    double dx = _popupRect.left;
    // limiting X offset
    dx = max(_screenBorderPadding, dx);
    final rightBorderPosition = dx + childSize.width;
    final rightScreenBorderOverflow = rightBorderPosition - size.width;
    if (rightScreenBorderOverflow >= 0) {
      dx -= rightScreenBorderOverflow + _screenBorderPadding;
    }

    const _verticalMargin = 30.0;
    // under the desired position
    double dy = position.dy + _verticalMargin;
    final bottomBorderPosition = dy + childSize.height;
    final bottomScreenBorderOverflow = bottomBorderPosition - size.height;
    // if not enough space underneath, rendering above the desired position
    if (bottomScreenBorderOverflow >= 0) {
      final newBottomBorderPosition = position.dy - childSize.height;
      dy = newBottomBorderPosition - _verticalMargin;
    }

    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(covariant PopupOverlayLayoutDelegate oldDelegate) {
    return false;
  }
}
