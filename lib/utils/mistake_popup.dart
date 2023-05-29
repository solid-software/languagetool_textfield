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
  final MistakeBuilderCallback? mistakeBuilder;

  /// [MistakePopup] constructor
  const MistakePopup({required this.popupRenderer, this.mistakeBuilder});

  /// Show popup at specified [popupPosition] with info about [mistake]
  void show(
    BuildContext context,
    Mistake mistake,
    Offset popupPosition,
    ColoredTextEditingController controller,
  ) {
    final MistakeBuilderCallback builder =
        mistakeBuilder ?? LanguageToolMistakePopup.new;

    popupRenderer.render(
      context,
      position: popupPosition,
      popupBuilder: (context) => builder.call(
        popupRenderer: popupRenderer,
        mistake: mistake,
        controller: controller,
        mistakePosition: popupPosition,
      ),
    );
  }
}

/// Default mistake window that looks similar to LanguageTool popup
class LanguageToolMistakePopup extends StatelessWidget {
  static const double _defaultVerticalMargin = 25.0;
  static const double _defaultHorizontalMargin = 10.0;
  static const double _defaultMaxWidth = 250.0;

  /// Renderer used to display this window.
  final PopupOverlayRenderer popupRenderer;

  /// Mistake object
  final Mistake mistake;

  /// Controller of the text where mistake was found
  final ColoredTextEditingController controller;

  /// An on-screen position of the mistake
  final Offset mistakePosition;

  /// A maximum width of the popup.
  /// If infinity, the popup will use all the available horizontal space.
  final double maxWidth;

  /// A maximum height of the popup.
  /// If infinity, the popup will use all the available height between the
  /// [mistakePosition] and the furthest border of the layout constraints.
  final double maxHeight;

  /// Horizontal popup margin.
  final double horizontalMargin;

  /// Vertical popup margin.
  final double verticalMargin;

  /// [LanguageToolMistakePopup] constructor
  const LanguageToolMistakePopup({
    super.key,
    required this.popupRenderer,
    required this.mistake,
    required this.controller,
    required this.mistakePosition,
    this.maxWidth = _defaultMaxWidth,
    this.maxHeight = double.infinity,
    this.horizontalMargin = _defaultHorizontalMargin,
    this.verticalMargin = _defaultVerticalMargin,
  });

  @override
  Widget build(BuildContext context) {
    const _borderRadius = 10.0;
    const _mistakeNameFontSize = 13.0;
    const _mistakeMessageFontSize = 15.0;
    const _replacementButtonsSpacing = 10.0;

    const padding = 10.0;

    final availableSpace = _calculateAvailableSpace(context);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: availableSpace,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
          vertical: verticalMargin,
        ),
        padding: const EdgeInsets.all(padding),
        decoration: BoxDecoration(
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 20)],
          color: Colors.white,
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // mistake type
                  Text(
                    mistake.type.name,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: _mistakeNameFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: padding),

                  // mistake message
                  Text(
                    mistake.message,
                    style: const TextStyle(fontSize: _mistakeMessageFontSize),
                  ),
                  const SizedBox(height: padding),
                ],
              ),
            ),
            SliverList.builder(
              itemCount: mistake.replacements.length,
              itemBuilder: (context, index) {
                final replacement = mistake.replacements[index];

                return Padding(
                  padding: const EdgeInsets.all(_replacementButtonsSpacing / 2),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.replaceMistake(mistake, replacement);
                      popupRenderer.dismiss();
                    },
                    child: Text(replacement),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  double _calculateAvailableSpace(BuildContext context) {
    // final margins = horizontalMargin * 2 + verticalMargin * 2;
    final mediaQuery = MediaQuery.of(context);

    final availableSpaceBottom = mediaQuery.size.height - mistakePosition.dy;
    final availableSpaceTop = mistakePosition.dy;

    return min(max(availableSpaceBottom, availableSpaceTop), maxHeight);
  }
}
