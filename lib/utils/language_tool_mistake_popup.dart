import 'dart:math';

import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

/// Popup that shows information about mistake and offers word replacements
class LanguageToolMistakePopup {
  /// Mistake object to show info about
  final Mistake mistake;

  /// Position of [TextSpan] which contains mistake
  final Offset mistakeOffset;

  /// Width of popup
  final double width;

  /// Height of popup
  final double height;

  OverlayEntry? _overlayEntry;

  /// Create [LanguageToolMistakePopup] with specified mistake and position
  /// where popup need to be appeared
  LanguageToolMistakePopup({
    required this.mistake,
    required this.mistakeOffset,
    required this.width,
    required this.height,
  });

  /// Show popup with information about mistake
  void show(BuildContext context) {
    final Offset _offset = _calculateOffset(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fromRect(
        rect: Rect.fromLTWH(_offset.dx, _offset.dy, width, height),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            dismiss();
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(8),
              width: width,
              height: height,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(color: Colors.grey, blurRadius: 20)
                ],
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
                          // todo replace word
                          throw UnimplementedError("what the flutter?");
                        },
                        child: Text(mistake.replacements[index]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Remove popup
  void dismiss() {
    _overlayEntry?.remove();
  }

  Offset _calculateOffset(BuildContext context) {
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
