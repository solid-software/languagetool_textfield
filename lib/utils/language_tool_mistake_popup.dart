import 'dart:math';

import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';

/// Popup that shows information about mistake and offers word replacements
class LanguageToolMistakePopup {
  /// Callback that returns widget for given mistake
  final Widget Function(
    Mistake mistake,
    ColoredTextEditingController controller,
  )? popupBuilder;

  /// Width of popup
  final double width;

  /// Height of popup
  final double height;

  OverlayEntry? _overlayEntry;

  /// [LanguageToolMistakePopup] constructor
  LanguageToolMistakePopup({
    required this.width,
    required this.height,
    this.popupBuilder,
  });

  /// Show popup with information about mistake
  void show(
    BuildContext context,
    Mistake mistake,
    Offset mistakeOffset,
    ColoredTextEditingController controller,
  ) {
    final Offset _popupPosition = _calculatePosition(context, mistakeOffset);
    final _popupBuilderToUse = popupBuilder ?? _defaultPopupBuilder;

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
                child: _popupBuilderToUse(mistake, controller),
              ),
            ],
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_createdEntry);
    _overlayEntry = _createdEntry;
  }

  Widget _defaultPopupBuilder(
    Mistake mistake,
    ColoredTextEditingController controller,
  ) {
    const _borderRadius = 10.0;
    const _mistakeNameFontSize = 13.0;
    const _mistakeMessageFontSize = 15.0;
    const _replacementsButtonsRowHeight = 35.0;

    return Container(
      padding: const EdgeInsets.all(10),
      width: width,
      height: height,
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
                  dismiss();
                },
                child: Text(mistake.replacements[index]),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Remove popup
  void dismiss() {
    _overlayEntry?.remove();
  }

  Offset _calculatePosition(BuildContext context, Offset mistakeOffset) {
    final _view = View.of(context);
    final _screenSize = _view.physicalSize / _view.devicePixelRatio;
    final _popupRect = Rect.fromCenter(
      center: mistakeOffset,
      width: width,
      height: height,
    );
    const _popupBorderPadding = 10.0;
    const _popupYDistance = 30.0;

    double dx = _popupRect.left;
    // limiting X offset left border
    dx = max(_popupBorderPadding, dx);
    // limiting X offset right border
    if ((dx + width) > _screenSize.width) {
      dx = (_screenSize.width - width) - _popupBorderPadding;
    }

    // under the mistake
    double dy = mistakeOffset.dy + _popupYDistance;
    // if not enough space underneath, rendering above the mistake
    if ((dy + height) > _screenSize.height) {
      dy = (mistakeOffset.dy - height) - _popupYDistance;
    }

    return Offset(dx, dy);
  }
}
