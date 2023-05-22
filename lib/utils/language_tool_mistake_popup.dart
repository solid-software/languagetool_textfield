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

    _overlayEntry = OverlayEntry(
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

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _defaultPopupBuilder(
    Mistake mistake,
    ColoredTextEditingController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 20)],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mistake.type.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            mistake.message,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
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
    const _defaultPopupPadding = 10.0;

    double dx = _popupRect.left;
    dx = max(_defaultPopupPadding, dx);

    if (dx + width > _screenSize.width) {
      dx = _screenSize.width - width - _defaultPopupPadding;
    }

    double dy = mistakeOffset.dy + 30;
    if (dy <= MediaQuery.of(context).padding.top + _defaultPopupPadding) {
      dy = mistakeOffset.dy - _defaultPopupPadding * 3;
    }

    return Offset(dx, dy);
  }
}
