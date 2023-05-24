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
    const _replacementButtonsSpacing = 10.0;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 20)],
        color: Colors.white,
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
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
          const SizedBox(height: 10),

          // mistake message
          Text(
            mistake.message,
            style: const TextStyle(fontSize: _mistakeMessageFontSize),
          ),
          const SizedBox(height: 10),

          // replacements
          Wrap(
            spacing: _replacementButtonsSpacing,
            direction: Axis.horizontal,
            children: mistake.replacements
                .map(
                  (replacement) => ElevatedButton(
                    onPressed: () {
                      controller.replaceMistake(mistake, replacement);
                      popupRenderer.dismiss();
                    },
                    child: Text(replacement),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}
