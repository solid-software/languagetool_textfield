import 'dart:math';

import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/typedefs.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

/// Builder class that uses specified [popupRenderer] and [mistakeBuilder]
/// to create mistake popup
class MistakePopup {
  /// PopupRenderer class that used to render popup on the screen
  final PopupOverlayRenderer popupRenderer;

  /// Optional builder function that creates popup widget
  MistakeBuilderCallback? mistakeBuilder;

  /// [MistakePopup] constructor
  MistakePopup({
    required this.popupRenderer,
    this.mistakeBuilder,
  });

  /// Show popup at specified [popupPosition] with info about [mistake]
  void show(
    BuildContext context,
    Mistake mistake,
    Offset popupPosition,
    ColoredTextEditingController controller,
  ) {
    final _builderToUse = mistakeBuilder ?? defaultPopupBuilder;

    popupRenderer.render(
      context,
      position: popupPosition,
      popupBuilder: () => _builderToUse(mistake, controller),
    );
  }

  /// Widget builder that creates window looking similar to LanguageTool popup
  Widget defaultPopupBuilder(
    Mistake mistake,
    ColoredTextEditingController controller,
  ) {
    const _borderRadius = 10.0;
    const _mistakeNameFontSize = 13.0;
    const _mistakeMessageFontSize = 15.0;
    const _replacementsButtonsRowHeight = 35.0;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 20)],
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mistake.type.name,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: _mistakeNameFontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                mistake.message,
                style: const TextStyle(
                  // fontStyle: FontStyle.italic,
                  fontSize: _mistakeMessageFontSize,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: _replacementsButtonsRowHeight,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                width: 5,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: mistake.replacements.length,
              itemBuilder: (context, index) => ElevatedButton(
                onPressed: () {
                  controller.replaceMistake(
                    mistake,
                    mistake.replacements[index],
                  );
                  popupRenderer.dismiss();
                },
                child: Text(mistake.replacements[index]),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// Renderer used to show popup window overlay
class PopupOverlayRenderer {
  OverlayEntry? _overlayEntry;

  /// Width of popup
  final double width;

  /// Height of popup
  final double height;

  /// [PopupOverlayRenderer] constructor
  PopupOverlayRenderer({required this.width, required this.height});

  /// Render overlay entry on the screen with dismiss logic
  OverlayEntry render(
    BuildContext context, {
    required Offset position,
    required Widget Function() popupBuilder,
  }) {
    final Offset _popupPosition = _calculatePosition(context, position);

    final _createdEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          dismiss();
        },
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                left: _popupPosition.dx,
                top: _popupPosition.dy,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: popupBuilder(),
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

  /// Function that bounds given offset to screen sizes
  Offset _calculatePosition(BuildContext context, Offset position) {
    final _view = View.of(context);
    final _screenSize = _view.physicalSize / _view.devicePixelRatio;
    final _popupRect = Rect.fromCenter(
      center: position,
      width: width,
      height: height,
    );
    const _popupBorderPadding = 10.0;
    const _popupYDistance = 30.0;

    double dx = _popupRect.left;
    // limiting X offset by left border
    dx = max(_popupBorderPadding, dx);
    // limiting X offset by right border
    if ((dx + width) > _screenSize.width) {
      dx = (_screenSize.width - width) - _popupBorderPadding;
    }

    // under the desired position
    double dy = position.dy + _popupYDistance;
    // if not enough space underneath, rendering above the desired position
    if ((dy + height) > _screenSize.height) {
      dy = (position.dy - height) - _popupYDistance;
    }

    return Offset(dx, dy);
  }

  /// Remove popup
  void dismiss() {
    _overlayEntry?.remove();
  }
}
