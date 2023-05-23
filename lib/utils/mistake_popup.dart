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
    popupRenderer.render(
      context,
      position: popupPosition,
      popupBuilder: (context) =>
          mistakeBuilder?.call(popupRenderer, mistake, controller) ??
          LanguageToolMistakePopup(
            popupRenderer: popupRenderer,
            mistake: mistake,
            controller: controller,
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
    required WidgetBuilder popupBuilder,
  }) {
    final Offset _popupPosition = _calculatePosition(context, position);

    final _createdEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: dismiss,
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

  /// Function that bounds given offset to screen sizes
  Offset _calculatePosition(BuildContext context, Offset position) {
    final _screenSize = MediaQuery.of(context).size;
    final _popupRect = Rect.fromCenter(
      center: position,
      width: width,
      height: height,
    );
    const _screenBorderPadding = 10.0;

    double dx = _popupRect.left;
    // limiting X offset
    dx = max(_screenBorderPadding, dx);
    final rightBorderPosition = dx + width;
    final rightScreenBorderOverflow = rightBorderPosition - _screenSize.width;
    if (rightScreenBorderOverflow >= 0) {
      dx -= rightScreenBorderOverflow + _screenBorderPadding;
    }

    const _verticalMargin = 30.0;
    // under the desired position
    double dy = position.dy + _verticalMargin;
    final bottomBorderPosition = dy + height;
    final bottomScreenBorderOverflow =
        bottomBorderPosition - _screenSize.height;
    // if not enough space underneath, rendering above the desired position
    if (bottomScreenBorderOverflow >= 0) {
      final newBottomBorderPosition = position.dy - height;
      dy = newBottomBorderPosition - _verticalMargin;
    }

    return Offset(dx, dy);
  }

  /// Remove popup
  void dismiss() {
    _overlayEntry?.remove();
  }
}

/// Default mistake window that looks similar to LanguageTool popup
class LanguageToolMistakePopup extends StatelessWidget {
  /// [LanguageToolMistakePopup] constructor
  const LanguageToolMistakePopup({
    super.key,
    required this.popupRenderer,
    required this.mistake,
    required this.controller,
  });

  /// Renderer used to display this window.
  final PopupOverlayRenderer popupRenderer;

  /// Mistake object
  final Mistake mistake;

  /// Controller of the text where mistake was found
  final ColoredTextEditingController controller;

  @override
  Widget build(BuildContext context) {
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
              separatorBuilder: (context, index) => const SizedBox(width: 5),
              scrollDirection: Axis.horizontal,
              itemCount: mistake.replacements.length,
              itemBuilder: (context, index) {
                final replacement = mistake.replacements[index];

                return ElevatedButton(
                  onPressed: () {
                    controller.replaceMistake(mistake, replacement);
                    popupRenderer.dismiss();
                  },
                  child: Text(replacement),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
