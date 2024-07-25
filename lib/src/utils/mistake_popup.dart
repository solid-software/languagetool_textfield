import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_textfield/src/core/controllers/language_tool_controller.dart';
import 'package:languagetool_textfield/src/core/langtool_images.dart';
import 'package:languagetool_textfield/src/domain/mistake.dart';
import 'package:languagetool_textfield/src/domain/typedefs.dart';
import 'package:languagetool_textfield/src/utils/extensions/string_extension.dart';
import 'package:languagetool_textfield/src/utils/popup_overlay_renderer.dart';

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
    BuildContext context, {
    required Mistake mistake,
    required Offset popupPosition,
    required LanguageToolController controller,
    ValueChanged<TapDownDetails>? onClose,
  }) {
    final MistakeBuilderCallback builder =
        mistakeBuilder ?? LanguageToolMistakePopup.new;

    popupRenderer.render(
      context,
      position: popupPosition,
      onClose: onClose,
      popupBuilder: (_) => builder.call(
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
  static const _iconSize = 25.0;

  /// Renderer used to display this window.
  final PopupOverlayRenderer popupRenderer;

  /// Mistake object
  final Mistake mistake;

  /// Controller of the text where mistake was found
  final LanguageToolController controller;

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

  /// Mistake suggestion style.
  final ButtonStyle? mistakeStyle;

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
    this.mistakeStyle,
  });

  @override
  Widget build(BuildContext context) {
    const _borderRadius = 10.0;
    const _mistakeNameFontSize = 11.0;
    const _mistakeMessageFontSize = 13.0;
    const _replacementButtonsSpacing = 4.0;
    const _replacementButtonsSpacingMobile = -6.0;
    const _paddingBetweenTitle = 14.0;
    const _titleLetterSpacing = 0.56;
    const _dismissSplashRadius = 2.0;

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
        decoration: BoxDecoration(
          color: const Color.fromRGBO(241, 243, 248, 1.0),
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 8)],
        ),
        padding: const EdgeInsets.only(
          top: 8,
          bottom: 4,
          left: 4,
          right: 4,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Image.asset(
                              LangToolImages.logo,
                              width: _iconSize,
                              height: _iconSize,
                              package: 'languagetool_textfield',
                            ),
                          ),
                          const Text('Correct'),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 12,
                      ),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      splashRadius: _dismissSplashRadius,
                      onPressed: () {
                        _dismissDialog();
                        controller.onClosePopup();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(_borderRadius),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: _paddingBetweenTitle,
                        ),
                        child: Text(
                          mistake.type.name.capitalize(),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: _mistakeNameFontSize,
                            fontWeight: FontWeight.w600,
                            letterSpacing: _titleLetterSpacing,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: padding),
                        child: Text(
                          mistake.message,
                          style: const TextStyle(
                            fontSize: _mistakeMessageFontSize,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: _replacementButtonsSpacing,
                        runSpacing: kIsWeb
                            ? _replacementButtonsSpacing
                            : _replacementButtonsSpacingMobile,
                        children: mistake.replacements
                            .map(
                              (replacement) => ElevatedButton(
                                onPressed: () => _fixTheMistake(replacement),
                                style: mistakeStyle ??
                                    ElevatedButton.styleFrom(
                                      elevation: 0,
                                      minimumSize: const Size(40, 36),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                    ),
                                child: Text(replacement),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateAvailableSpace(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final availableSpaceBottom = mediaQuery.size.height - mistakePosition.dy;
    final availableSpaceTop = mistakePosition.dy;

    return min(max(availableSpaceBottom, availableSpaceTop), maxHeight);
  }

  void _dismissDialog() {
    popupRenderer.dismiss();
  }

  void _fixTheMistake(String replacement) {
    controller.replaceMistake(mistake, replacement);
    _dismissDialog();
  }
}
