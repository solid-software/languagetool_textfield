import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/utils/error_wrapper.dart';
import 'package:throttling/throttling.dart';

/// A language check service with debouncing.
class DebounceLangToolService extends LanguageCheckService {
  /// A base language check service.
  final LanguageCheckService baseService;

  /// A debouncing used to debounce the API calls.
  final Debouncing debouncing;

  /// Creates a new instance of the [DebounceLangToolService] class.
  DebounceLangToolService(
    this.baseService,
    Duration debouncingDuration,
  ) : debouncing = Debouncing(duration: debouncingDuration);

  @override
  Future<ErrorWrapper<List<Mistake>>> findMistakes(String text) async {
    final value = await debouncing.debounce(() {
      return baseService.findMistakes(text);
    }) as ErrorWrapper<List<Mistake>>?;

    return value ?? ErrorWrapper.success(<Mistake>[].toList(growable: true));
  }
}
