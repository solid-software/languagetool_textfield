import 'dart:async';

import 'package:flutter/material.dart';
import 'package:language_tool/language_tool.dart';
import 'package:languagetool_text_field/controllers/timeout.dart';

import 'package:languagetool_text_field/styles/languagetool_default_styles.dart';
import 'package:rate_limiter/rate_limiter.dart';

/// Custom controller which allows different styles in one TextField
///  by concatanating different TextSpan widgets
class CustomTextFieldController extends TextEditingController {
  /// List of mistakes, currently presented in the text
  List<WritingMistake> _mistakes = [];

  final Timeout _timeout = Timeout(const Duration(seconds: 3));

  final _tool = LanguageTool();

  /// Text style for style mistakes.
  final TextStyle styleMistakeStyle;

  /// Text style for grammar mistakes.
  final TextStyle grammarMistakeStyle;

  /// Text style for typographical mistakes.
  final TextStyle typographicalMistakeStyle;

  /// Text style for unidentified mistakes.
  final TextStyle defaultMistakeStyle;

  /// Constructor for this custom controller
  CustomTextFieldController({
    /// current text value of the controller.
    required String text,
    this.styleMistakeStyle = LanguageToolDefaultStyles.styleMistakeStyle,
    this.grammarMistakeStyle = LanguageToolDefaultStyles.grammarMistakeStyle,
    this.typographicalMistakeStyle =
        LanguageToolDefaultStyles.typographicalMistakeStyle,
    this.defaultMistakeStyle = LanguageToolDefaultStyles.defaultMistakeStyle,
  }) : super(text: text);

  /// This function nulls the mistakes before the API call was made
  /// to avoid conflicts
  void _clearMistakes() {
    _mistakes = [];
  }

  /// Function that makes API call and updates the internal array with mistakes.
  Future updateValidation(String text) async {
    final throttledFunction = throttle(
      () async {
        _mistakes = await _tool.check(text);
      },
      const Duration(seconds: 3),
    );

    throttledFunction();
  }

  TextStyle _defineMistakeStyle(String type) {
    switch (type) {
      case 'typographical':
        return typographicalMistakeStyle;
      case 'grammar':
        return grammarMistakeStyle;
      case 'style':
        return styleMistakeStyle;
      default:
        return LanguageToolDefaultStyles.defaultMistakeStyle;
    }
  }

  TextSpan _buildMistakeSpan(
    WritingMistake currentMistake,
    TextStyle mistakeStyle,
  ) {
    return TextSpan(
      text: text.substring(
        currentMistake.offset,
        currentMistake.offset + currentMistake.length,
      ),
      style: mistakeStyle,
    );
  }

  TextSpan _buildCleanSpan(
    int start,
    int end,
  ) {
    return TextSpan(
      text: text.substring(
        start,
        end,
      ),
      style: LanguageToolDefaultStyles.noMistakeStyle,
    );
  }

  /// This function creates a TextSpan array with the actual text,
  /// where mistakes are highlited and addressed
  List<TextSpan> _configureText(String text) {
    if (_mistakes.isEmpty) {
      return [
        TextSpan(text: text, style: LanguageToolDefaultStyles.noMistakeStyle)
      ];
    }

    final List<TextSpan> result = [];
    result.add(
      TextSpan(
        text: text.substring(0, _mistakes.first.offset),
      ),
    );
    for (int i = 0; i < _mistakes.length; i++) {
      final currentMistake = _mistakes[i];

      final mistakeStyle = _defineMistakeStyle(currentMistake.issueType);
      result.add(
        _buildMistakeSpan(currentMistake, mistakeStyle),
      );
      final hasNextMistake = i + 1 < _mistakes.length;
      if (hasNextMistake) {
        final nextMistakeOffset = _mistakes[i + 1].offset;
        result.add(
          _buildCleanSpan(
            currentMistake.offset + currentMistake.length,
            nextMistakeOffset,
          ),
        );
      } else {
        result.add(
          _buildCleanSpan(
            currentMistake.offset + currentMistake.length,
            text.length,
          ),
        );
      }
    }

    return result;
  }

  @override
  void notifyListeners() {
    _clearMistakes();
    super.notifyListeners();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    List<TextSpan> result = [];
    result = _configureText(text);

    return TextSpan(children: result);
  }
}
