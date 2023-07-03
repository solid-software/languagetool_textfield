import 'package:languagetool_textfield/domain/language_check_service.dart';
import 'package:languagetool_textfield/domain/mistake.dart';
import 'package:languagetool_textfield/utils/result.dart';
import 'package:throttling/throttling.dart';

/// A language check service with debouncing.
class DebounceLangToolService extends LanguageCheckService {
  // Declare a flag to track ongoing language check requests
  int _lastRequestId = 0;

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
  Future<Result<List<Mistake>>?> findMistakes(String text) async {
    // Set the flag to indicate an ongoing request
    // Increment the request ID to track the most recent request
    final requestId = ++_lastRequestId;
    final value =
        await debouncing.debounce(() => baseService.findMistakes(text))
            as Result<List<Mistake>>?;

    // Check if a newer request has been initiated during the API call
    if (requestId != _lastRequestId) return null;
    _lastRequestId = 0;

    return value;
  }

  @override
  Future<void> dispose() async {
    await debouncing.close();
    await baseService.dispose();
  }
}
