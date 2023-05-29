/// A monad wrapping a non-nullable type [T] alongside the possible
/// error.
class Result<T> {
  /// A wrapped object of type [T].
  /// If the error has occurred, it will be null.
  final T? _result;

  /// The error which may have occurred.
  /// If the error has not occurred, it will ne null.
  final Object? error;

  /// Returns a wrapped object of type [T], if the result is present.
  ///
  /// **Check if [hasResult] before calling this getter.**
  /// If doesn't have the result, will throw a [StateError].
  T get result {
    final res = _result;

    if (res == null) {
      throw StateError(
        'No result has been wrapped. Consider checking the [hasResult] '
        'getter before retrieving the result from the ErrorWrapper.',
      );
    }

    return res;
  }

  /// Returns true if no error has occurred during the API request.
  bool get hasResult => _result != null;

  /// Creates a new success [ErrorWrapper] with the given [result].
  const Result.success(this._result) : error = null;

  /// Creates a new error [ErrorWrapper] with the given error.
  const Result.error(Object this.error) : _result = null;

  /// Maps this [ErrorWrapper] of type [T] to an ErrorWrapper of type [T1] with
  /// the given [mapper].
  Result<T1> map<T1>(T1 Function(T) mapper) {
    if (hasResult) {
      return Result.success(mapper(result));
    }

    return Result<T1>.error(error ?? 'Error was not specified');
  }
}
