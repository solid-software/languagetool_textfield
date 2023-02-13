import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:throttling/throttling.dart';

class DebounceLangToolService extends LanguageCheckService {
  final LanguageCheckService baseService;
  final Debouncing debouncing;

  DebounceLangToolService(
    this.baseService,
    Duration debouncingDuration,
  ) : debouncing = Debouncing(duration: debouncingDuration);

  @override
  Future<List<Mistake>> findMistakes(String text) =>
      debouncing.debounce(() => baseService.findMistakes(text))
          as Future<List<Mistake>>;
}
