/// Extension on String.
extension StringExtension on String {
  /// Returns a capitalized String (i.e 'text' -> 'Text').
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
