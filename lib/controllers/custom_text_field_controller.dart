import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:language_tool/language_tool.dart';
import 'package:languagetool_text_field/styles/languagetool_default_styles.dart';

/// Custom controller which allows different styles in one TextField
///  by concatanating different TextSpan widgets
class CustomTextFieldController extends TextEditingController {
  /// List of mistakes, currently presented in the text

  List<WritingMistake> mistakes = [];
  final _tool = LanguageTool();

  /// Highlite style mistake with this specified TextStyle.
  /// If this is not stated, uses default instead
  final TextStyle styleMistakeStyle;

  /// Highlite grammar mistake with this specified TextStyle.
  /// If this is not stated, uses default instead
  final TextStyle grammarMistakeStyle;

  /// Highlite typographical mistake with this specified TextStyle.
  /// If this is not stated, uses default instead
  final TextStyle typographicalMistakeStyle;

  /// default highlight for all unclassified mistakes.
  /// If this is not stated, uses default instead
  final TextStyle defaulMistakeStyle;

  /// Constructor for this custom controller
  CustomTextFieldController({
    /// current text value of the controller.
    required String text,
    this.styleMistakeStyle = LanguageToolDefaultStyles.styleMistakeStyle,
    this.grammarMistakeStyle = LanguageToolDefaultStyles.grammarMistakeStyle,
    this.typographicalMistakeStyle =
        LanguageToolDefaultStyles.typographicalMistakeStyle,
    this.defaulMistakeStyle = LanguageToolDefaultStyles.defaulMistakeStyle,
  }) : super(text: text);

  /// Function that makes API call and updates the internal array with mistakes.
  Future updateValidation(String text) async {
    // delay for 300 milliseconds befor the call
    await Future<dynamic>.delayed(
      const Duration(seconds: 3),
    );
    mistakes = await _tool.check(text);
  }

  /// mistake dialog, which allows us to replace given part of the text
  void _showMistakeDialog(WritingMistake mistakeInfo, BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_context) {
        return AlertDialog(
          title: Text("Type: ${mistakeInfo.issueType}"),
          content: SingleChildScrollView(
            child: Text("Can be replaced: ${mistakeInfo.replacements.first}"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Don't replace"),
              onPressed: () {
                Navigator.of(_context).pop();
              },
            ),
            TextButton(
              child: const Text('Replace'),
              onPressed: () {
                final errorText = text.substring(
                  mistakeInfo.offset,
                  mistakeInfo.offset + mistakeInfo.length,
                );
                final String rightText = mistakeInfo.replacements.first;
                final String newText = text.replaceFirst(errorText, rightText);
                text = newText;

                updateValidation(text);
                _configureText(newText, context);
                Navigator.of(_context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  TextStyle _defineMistakeStyle(String type) {
    var mistakeStyle = LanguageToolDefaultStyles.noMistakeStyle;
    switch (type) {
      case "typographical":
        mistakeStyle = typographicalMistakeStyle;
        break;
      case 'grammar':
        mistakeStyle = grammarMistakeStyle;
        break;
      case 'style':
        mistakeStyle = styleMistakeStyle;
        break;
      default:
        mistakeStyle = LanguageToolDefaultStyles.defaulMistakeStyle;
        break;
    }

    return mistakeStyle;
  }

  /// This function creates a TextSpan array with the actual text,
  /// where mistakes are highlited and addressed
  List<TextSpan> _configureText(String text, BuildContext context) {
    try {
      if (mistakes.isNotEmpty) {
        final List<TextSpan> result = [];
        result.add(
          TextSpan(
            text: text.substring(0, mistakes.first.offset),
          ),
        );
        for (int i = 0; i < mistakes.length; i++) {
          final currentMistake = mistakes[i];
          final mistakeStyle = _defineMistakeStyle(currentMistake.issueType);
          result.add(
            TextSpan(
              text: text.substring(
                currentMistake.offset,
                currentMistake.offset + currentMistake.length,
              ),
              style: mistakeStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  // print(mistakes![i].issueType);
                  // print(mistakes![i].issueDescription);
                  _showMistakeDialog(currentMistake, context);
                },
            ),
          );
          final hasNextMistake = i + 1 < mistakes.length;
          if (hasNextMistake) {
            final nextMistakeOffset = mistakes[i + 1].offset;
            result.add(
              TextSpan(
                text: text.substring(
                  currentMistake.offset + currentMistake.length,
                  nextMistakeOffset,
                ),
                style: LanguageToolDefaultStyles.noMistakeStyle,
              ),
            );
          } else {
            result.add(
              TextSpan(
                text: text.substring(
                  currentMistake.offset + currentMistake.length,
                  text.length,
                ),
                style: LanguageToolDefaultStyles.noMistakeStyle,
              ),
            );
          }
        }

        return result;
      }
    } catch (e) {
      // print(e);
    }

    return [
      TextSpan(text: text, style: LanguageToolDefaultStyles.noMistakeStyle)
    ];
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> result = _configureText(text, context);

    return TextSpan(children: result); //  TextSpan(children: result);
  }
}
