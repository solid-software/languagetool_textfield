import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:language_tool/language_tool.dart';
import 'package:languagetool_text_field/styles/languagetool_default_styles.dart';

/// Custom controller which allows different styles in one TextField
///  by concatanating different TextSpan widgets
class CustomTextFieldController extends TextEditingController {
  /// List of mistakes, currently presented in the text
  dynamic _context;
  List<WritingMistake>? mistakes;
  final _tool = LanguageTool();

  /// Highlite style mistake with this specified TextStyle. If this is not stated, uses default instead
  final TextStyle? styleMistakeStyle;

  /// Highlite grammar mistake with this specified TextStyle. If this is not stated, uses default instead
  final TextStyle? grammarMistakeStyle;

  /// Highlite typographical mistake with this specified TextStyle. If this is not stated, uses default instead
  final TextStyle? typographicalMistakeStyle;

  /// default highlight for all unclassified mistakes. If this is not stated, uses default instead
  final TextStyle? defaulMistakeStyle;

  /// Constructor for this custom controller
  CustomTextFieldController({
    /// current text value of the controller.
    required String text,
    this.styleMistakeStyle,
    this.grammarMistakeStyle,
    this.typographicalMistakeStyle,
    this.defaulMistakeStyle,
  }) : super(text: text);

  Future updateValidation(dynamic context, String text) async {
    _context = context;
    mistakes = await _tool.check(text);
  }

  Future updateMistakes(String text) async {
    mistakes = await _tool.check(text);
  }

  /// mistake dialog, which allows us to replace given part of the text
  void _showMistakeDialog(WritingMistake mistakeInfo) {
    showDialog<void>(
      context: _context,
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
                String errorText = text.substring(mistakeInfo.offset,
                    mistakeInfo.offset + mistakeInfo.length);
                String rightText = mistakeInfo.replacements.first;
                String newText = text.replaceFirst(errorText, rightText);
                text = newText;
                updateValidation(_context, text);
                _configureText(newText);
                Navigator.of(_context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // TODO: Implement a new algorithm
  List<TextSpan> _newConfigureText(String text) {
    List<TextSpan> result = [];
    for (int i = 0; i < mistakes!.length; i++) {
      String rightText = '';
      int j = 0;
    }
    return [TextSpan(text: text, style: LanguageToolStyles.noMistakeStyle)];
  }

  // This is working bad
  List<TextSpan> _configureText(String text) {
    try {
      if (mistakes != null && mistakes!.isNotEmpty) {
        List<TextSpan> result = [];
        result.add(
          TextSpan(
            text: text.substring(0, mistakes!.first.offset),
          ),
        );
        for (int i = 0; i < mistakes!.length; i++) {
          var mistakeStyle = LanguageToolStyles.noMistakeStyle;
          switch (mistakes![i].issueType) {
            case "typographical":
              mistakeStyle = typographicalMistakeStyle ??
                  LanguageToolStyles.typographicalMistakeStyle;
              break;
            case 'grammar':
              mistakeStyle =
                  grammarMistakeStyle ?? LanguageToolStyles.grammarMistakeStyle;
              break;
            case 'style':
              mistakeStyle =
                  styleMistakeStyle ?? LanguageToolStyles.styleMistakeStyle;
              break;
            default:
              mistakeStyle = LanguageToolStyles.defaulMistakeStyle;
              break;
          }
          result.add(
            TextSpan(
              text: text.substring(
                mistakes![i].offset,
                mistakes![i].offset + mistakes![i].length,
              ),
              style: mistakeStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  // print(mistakes![i].issueType);
                  // print(mistakes![i].issueDescription);
                  _showMistakeDialog(mistakes![i]);
                },
            ),
          );
          if (i + 1 < mistakes!.length) {
            result.add(
              TextSpan(
                text: text.substring(
                  mistakes![i].offset + mistakes![i].length,
                  mistakes![i + 1].offset - 1,
                ),
                style: LanguageToolStyles.noMistakeStyle,
              ),
            );
          } else {
            result.add(
              TextSpan(
                text: text.substring(
                  mistakes![i].offset + mistakes![i].length,
                  text.length,
                ),
                style: LanguageToolStyles.typographicalMistakeStyle,
              ),
            );
          }
        }

        return result;
      }
    } catch (e) {
      print(e);
    }

    return [TextSpan(text: text, style: LanguageToolStyles.noMistakeStyle)];
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    _context = context;
    final List<TextSpan> result = _configureText(text);

    return TextSpan(children: result); //  TextSpan(children: result);
  }
}
