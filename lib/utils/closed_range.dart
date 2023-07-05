import 'dart:math';

/// The [ClosedRange] class represents a closed range of integers, defined
/// by a starting point and an ending point.
/// The start and end properties represent the bounds of the range.
class ClosedRange {
  /// The start of the closed range.
  final int start;

  /// The start of the closed range.
  final int end;

  /// Constructor for creating a ClosedRange object
  const ClosedRange(this.start, this.end);

  /// Checks if the given point is before the range
  bool isBefore(int point) => point < min(start, end);

  /// Checks if the given point is before or at the range
  bool isBeforeOrAt(int point) => point <= min(start, end);

  bool isAfter(int point) => point > max(start, end);

  bool isAfterOrAt(int point) => point >= max(start, end);

  /// Checks if the range contains the given point
  bool contains(int point) {
    return start <= point && point <= end;
  }

  /// Checks if the encompasses the entire range
  bool containsRange(ClosedRange other) {
    return contains(other.start) && contains(other.end);
  }

  /// Checks if the this range is within the boundaries of the another range
  bool overlapsWith(ClosedRange other) {
    return contains(other.start) || contains(other.end);
  }
}
