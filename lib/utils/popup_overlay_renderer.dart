import 'dart:math';

import 'package:flutter/material.dart';

/// defaultPopupWidth
const defaultPopupWidth = 250.0;

/// defaultHorizontalPadding
const defaultHorizontalPadding = 10.0;

/// defaultVerticalMargin
const defaultVerticalPadding = 30.0;

/// Renderer used to show popup window overlay
class PopupOverlayRenderer {
  OverlayEntry? _overlayEntry;

  /// Max width of popup window
  final double width;

  /// [PopupOverlayRenderer] constructor
  PopupOverlayRenderer({this.width = defaultPopupWidth});

  /// Render overlay entry on the screen with dismiss logic
  OverlayEntry render(
    BuildContext context, {
    required Offset position,
    required WidgetBuilder popupBuilder,
  }) {
    final _createdEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: dismiss,
        child: Material(
          color: Colors.transparent,
          type: MaterialType.canvas,
          child: Stack(
            children: [
              CustomSingleChildLayout(
                delegate: PopupOverlayLayoutDelegate(position),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width),
                  child: popupBuilder(context),
                ),
              ),
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
  final double width;

  /// desired position of popup window
  final Offset position;

  /// padding of screen for popup window
  final double horizontalPadding;

  /// vertical distance to offset from [position]
  final double verticalPadding;

  /// [PopupOverlayLayoutDelegate] constructor
  const PopupOverlayLayoutDelegate(
    this.position, {
    this.width = defaultPopupWidth,
    this.horizontalPadding = defaultHorizontalPadding,
    this.verticalPadding = defaultVerticalPadding,
  });

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
    double dx = _popupRect.left;
    // limiting X offset
    dx = max(horizontalPadding, dx);
    final rightBorderPosition = dx + childSize.width;
    final rightScreenBorderOverflow = rightBorderPosition - size.width;
    if (rightScreenBorderOverflow >= 0) {
      dx -= rightScreenBorderOverflow + horizontalPadding;
    }

    // under the desired position
    double dy = position.dy + verticalPadding;
    final bottomBorderPosition = dy + childSize.height;
    final bottomScreenBorderOverflow = bottomBorderPosition - size.height;
    // if not enough space underneath, rendering above the desired position
    if (bottomScreenBorderOverflow >= 0) {
      final newBottomBorderPosition = position.dy - childSize.height;
      dy = newBottomBorderPosition - verticalPadding;
    }

    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(covariant PopupOverlayLayoutDelegate oldDelegate) {
    return false;
  }
}
