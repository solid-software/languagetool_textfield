import 'package:languagetool_textfield/core/enums/mistake_type.dart';
import 'package:languagetool_textfield/client/language_tool_client.dart';
import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/domain/writing_mistake.dart';
import 'package:languagetool_textfield/utils/result.dart';

/// An implementation of language check service with language tool service.
class LangToolService extends LanguageCheckService {
  /// An instance of this class that is used to interact with LanguageTool API.
  final LanguageToolClient languageTool;

  /// Creates a new instance of the [LangToolService].
  const LangToolService(this.languageTool);

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
              type: _stringToMistakeType(
                m.issueType,
              ),
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

  MistakeType _stringToMistakeType(String issueType) {
    switch (issueType.toLowerCase()) {
      case 'misspelling':
        return MistakeType.misspelling;
      case 'typographical':
        return MistakeType.typographical;
      case 'grammar':
        return MistakeType.grammar;
      case 'uncategorized':
        return MistakeType.uncategorized;
      case 'non-conformance':
        return MistakeType.nonConformance;
      case 'style':
        return MistakeType.style;
      default:
        return MistakeType.other;
    }
  }
}
