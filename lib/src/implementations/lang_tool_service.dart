import 'package:languagetool_textfield/src/client/language_tool_client.dart';
import 'package:languagetool_textfield/src/domain/language_check_service.dart';
import 'package:languagetool_textfield/src/domain/mistake.dart';
import 'package:languagetool_textfield/src/domain/writing_mistake.dart';
import 'package:languagetool_textfield/src/utils/result.dart';

/// An implementation of language check service with language tool service.
class LangToolService extends LanguageCheckService {
  /// An instance of this class that is used to interact with LanguageTool API.
  final LanguageToolClient languageTool;

  @override
  String get language => languageTool.language;

  @override
  set language(String language) {
    languageTool.language = language;
  }

  /// Creates a new instance of the [LangToolService].
  LangToolService(this.languageTool);

  @override
  Future<Result<List<Mistake>>> findMistakes(String text) async {
    final writingMistakesWrapper = await languageTool
        .check(text)
        .then(Result.success)
        .catchError(Result<List<WritingMistake>>.error);

    final mistakesWrapper = writingMistakesWrapper.map(
      (mistakes) {
        return mistakes.map(
          (m) {
            return Mistake(
              message: m.message,
              type: m.issueType,
              offset: m.offset,
              length: m.length,
              replacements: m.replacements,
            );
          },
        ).toList(growable: false);
      },
    );

    return mistakesWrapper;
  }
}
