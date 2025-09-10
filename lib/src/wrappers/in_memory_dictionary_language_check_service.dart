import 'package:languagetool_textfield/languagetool_textfield.dart';

/// A language-check service that filters LanguageTool suggestions using an in-memory dictionary.
///
/// This class wraps a LanguageToolService and extends ThrottlingLanguageCheckService to
/// limit the frequency of requests. After performing a check with the underlying service,
/// it removes any reported mistakes whose corresponding word is present in the provided
/// in-memory dictionary (so user-defined or domain-specific words can be treated as correct).
///
/// The filtering is performed by extracting the substring of the input text using each
/// mistake's offset and endOffset and checking membership against the dictionary returned
/// by [getDictionary].
///
/// Note: the underlying service is throttled to avoid excessive requests; the throttling
/// behavior is provided by the superclass.
class InMemoryDictionaryLanguageCheckService
    extends ThrottlingLanguageCheckService {
  /// Callback that supplies the current set of words to be treated as correct.
  ///
  /// This function is invoked for each text check so the dictionary can be dynamic
  /// (for example, reflecting user edits or settings). It must return a Set<String>
  /// containing the words that should be ignored by the language checker.
  final Set<String> Function() getDictionary;

  /// Creates an InMemoryDictionaryLanguageCheckService that uses [getDictionary] to filter mistakes.
  ///
  /// The [getDictionary] callback is required and will be called for every check operation.
  /// The service delegates checking to an internal LanguageToolService and then filters
  /// the results based on the returned dictionary.
  InMemoryDictionaryLanguageCheckService({required this.getDictionary})
      : super(
          LanguageToolService(LanguageToolClient()),
          const Duration(milliseconds: 250),
        );

  @override
  Future<Result<List<Mistake>>?> findMistakes(String text) async {
    final result = await super.findMistakes(text);
    final dictionary = getDictionary();

    return result?.map(
      (mistakes) => mistakes.where(
        (mistake) {
          final word = text.substring(mistake.offset, mistake.endOffset);

          return !dictionary.contains(word);
        },
      ).toList(),
    );
  }
}
