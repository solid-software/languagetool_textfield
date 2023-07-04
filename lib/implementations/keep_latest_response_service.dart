import 'package:async/async.dart';

/// A service that executes asynchronous operations and ensures that only
/// the results of the latest operation are returned.
class KeepLatestResponseService {
  CancelableOperation<dynamic>? _currentOperation;

  /// Executes the latest operation and returns its result.
  /// Only the results of the most recent operation are returned,
  /// discarding any previous ongoing operations.
  Future<T?> processLatestOperation<T>(Future<T> Function() action) async {
    await _currentOperation?.cancel();
    _currentOperation = CancelableOperation<T>.fromFuture(action());

    return _currentOperation?.value as Future<T>?;
  }
}
