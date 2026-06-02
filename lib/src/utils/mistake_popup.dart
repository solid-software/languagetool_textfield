import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:languagetool_textfield/src/core/controllers/language_tool_controller.dart';
import 'package:languagetool_textfield/src/core/langtool_images.dart';
import 'package:languagetool_textfield/src/domain/mistake.dart';
import 'package:languagetool_textfield/src/domain/typedefs.dart';
import 'package:languagetool_textfield/src/utils/extensions/string_extension.dart';
import 'package:languagetool_textfield/src/utils/popup_overlay_renderer.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

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
  static const double _logoSize = 25;
  static const double _headerIconSize = 12;

  static const double _borderRadius = 10.0;
  static const double _mistakeNameFontSize = 11.0;
  static const double _mistakeMessageFontSize = 13.0;
  static const double _replacementButtonsSpacing = 4.0;
  static const double _replacementButtonsSpacingMobile = -6.0;
  static const double _paddingBetweenTitle = 14.0;
  static const double _titleLetterSpacing = 0.56;
  static const double _dismissSplashRadius = 2.0;
  static const double _padding = 10.0;

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

  /// Optional builder that adds additional actions to the header.
  final Future<void> Function(String)? addWordToDictionary;

  /// Creates a [LanguageToolMistakePopup].
  const LanguageToolMistakePopup({
    required this.popupRenderer,
    required this.mistake,
    required this.controller,
    required this.mistakePosition,
    this.maxWidth = _defaultMaxWidth,
    this.maxHeight = double.infinity,
    this.horizontalMargin = _defaultHorizontalMargin,
    this.verticalMargin = _defaultVerticalMargin,
    this.mistakeStyle,
    this.addWordToDictionary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final availableSpace = _calculateAvailableSpace(context);

    final colorScheme = Theme.of(context).colorScheme;

    return PointerInterceptor(
      child: ConstrainedBox(
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
            color: colorScheme.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(_borderRadius),
            boxShadow: [
              BoxShadow(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                blurRadius: 8,
              ),
            ],
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
                  child: IconTheme(
                    data: const IconThemeData(size: _headerIconSize),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Image.asset(
                                  LangToolImages.logo,
                                  width: _logoSize,
                                  height: _logoSize,
                                  package: 'languagetool_textfield',
                                ),
                              ),
                              const Text('Correct'),
                            ],
                          ),
                        ),
                        if (addWordToDictionary != null)
                          IconButton(
                            icon: const Icon(Icons.menu_book),
                            constraints: const BoxConstraints(),
                            splashRadius: _dismissSplashRadius,
                            onPressed: () =>
                                _addWordToDictionaryAndFix(mistake),
                          ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          constraints: const BoxConstraints(),
                          splashRadius: _dismissSplashRadius,
                          onPressed: () {
                            _dismissDialog();
                            controller.onClosePopup();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(_padding),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
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
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                              fontSize: _mistakeNameFontSize,
                              fontWeight: FontWeight.w600,
                              letterSpacing: _titleLetterSpacing,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: _padding),
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
      ),
    );
  }

  double _calculateAvailableSpace(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final availableSpaceBottom = mediaQuery.size.height - mistakePosition.dy;
    final availableSpaceTop = mistakePosition.dy;

    return min(max(availableSpaceBottom, availableSpaceTop), maxHeight);
  }

  Future<void> _addWordToDictionaryAndFix(Mistake mistake) async {
    final word = controller.text.substring(
      mistake.offset,
      mistake.endOffset,
    );

    await addWordToDictionary?.call(word);

    _fixTheMistake(word);
  }

  void _dismissDialog() {
    popupRenderer.dismiss();
  }

  void _fixTheMistake(String replacement) {
    controller.replaceMistake(mistake, replacement);
    _dismissDialog();
  }
}
