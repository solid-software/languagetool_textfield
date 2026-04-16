import 'dart:math';

import 'package:flutter/material.dart';

/// Renderer used to show popup window overlay
class PopupOverlayRenderer {
  OverlayEntry? _overlayEntry;

  /// [PopupOverlayRenderer] constructor
  PopupOverlayRenderer();

  /// Render overlay entry on the screen with dismiss logic
  OverlayEntry render(
    BuildContext context, {
    required Offset position,
    required WidgetBuilder popupBuilder,
    ValueChanged<TapDownDetails>? onClose,
  }) {
    final createdEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: onClose,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              CustomSingleChildLayout(
                delegate: PopupOverlayLayoutDelegate(position),
                child: TapRegion(
                  onTapOutside: (_) => dismiss(),
                  child: popupBuilder(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(createdEntry);
    _overlayEntry = createdEntry;

    return createdEntry;
  }

  /// Remove popup
  void dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

/// Class that calculates where to place popup window on the screen
class PopupOverlayLayoutDelegate extends SingleChildLayoutDelegate {
  /// desired position of popup window
  final Offset position;

  /// [PopupOverlayLayoutDelegate] constructor
  const PopupOverlayLayoutDelegate(this.position);

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return _calculatePosition(size, position, childSize);
  }

  Offset _calculatePosition(Size size, Offset position, Size childSize) {
    final popupRect = Rect.fromCenter(
      center: position,
      width: childSize.width,
      height: childSize.height,
    );
    double dx = popupRect.left;
    // limiting X offset
    dx = max(0, dx);
    final rightBorderPosition = dx + childSize.width;
    final rightScreenBorderOverflow = rightBorderPosition - size.width;
    if (rightScreenBorderOverflow > 0) {
      dx -= rightScreenBorderOverflow;
    }

    // under the desired position
    double dy = max(0, position.dy);
    final bottomBorderPosition = dy + childSize.height;
    final bottomScreenBorderOverflow = bottomBorderPosition - size.height;
    // if not enough space underneath, rendering above the desired position
    if (bottomScreenBorderOverflow > 0) {
      final newBottomBorderPosition = position.dy - childSize.height;
      dy = newBottomBorderPosition;
    }

    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(covariant PopupOverlayLayoutDelegate oldDelegate) {
    return false;
  }
}
