import 'dart:math';

import 'package:flutter/material.dart';

/// defaultPopupWidth
const defaultPopupWidth = 250.0;

/// defaultScreenBorderPadding
const defaultScreenBorderPadding = 10.0;

/// defaultVerticalMargin
const defaultVerticalMargin = 30.0;

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
  final double screenBorderPadding;

  /// vertical distance to offset from [position]
  final double verticalMargin;

  /// [PopupOverlayLayoutDelegate] constructor
  const PopupOverlayLayoutDelegate(
    this.position, {
    this.width = defaultPopupWidth,
    this.screenBorderPadding = defaultScreenBorderPadding,
    this.verticalMargin = defaultVerticalMargin,
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
    dx = max(screenBorderPadding, dx);
    final rightBorderPosition = dx + childSize.width;
    final rightScreenBorderOverflow = rightBorderPosition - size.width;
    if (rightScreenBorderOverflow >= 0) {
      dx -= rightScreenBorderOverflow + screenBorderPadding;
    }

    // under the desired position
    double dy = position.dy + verticalMargin;
    final bottomBorderPosition = dy + childSize.height;
    final bottomScreenBorderOverflow = bottomBorderPosition - size.height;
    // if not enough space underneath, rendering above the desired position
    if (bottomScreenBorderOverflow >= 0) {
      final newBottomBorderPosition = position.dy - childSize.height;
      dy = newBottomBorderPosition - verticalMargin;
    }

    return Offset(dx, dy);
  }

  @override
  bool shouldRelayout(covariant PopupOverlayLayoutDelegate oldDelegate) {
    return false;
  }
}
