/// Extension on String.
extension StringExtension on String {
  /// Returns a capitalized String (i.e 'text' -> 'Text').
  String capitalize() {
    return isEmpty
        ? this
        : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
