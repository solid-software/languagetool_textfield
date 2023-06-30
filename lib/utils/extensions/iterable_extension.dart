/// Extension on Iterable
extension IterableExtension<T> on Iterable<T> {
  /// Returns the first element in the iterable that satisfies the given [test] 
  /// function, or `null` if no element satisfies the condition.
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }

    return null;
  }
}
