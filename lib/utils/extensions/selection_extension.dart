import 'package:flutter/material.dart';
import 'package:languagetool_textfield/domain/mistake.dart';

/// Extension methods for the TextSelection class
extension SelectionExtension on TextSelection {
  /// Checks if the base offset of the TextSelection
  /// is before the mistake offset
  bool isBaseBeforeMistake(Mistake mistake) => base.offset < mistake.offset;

  /// Checks if the base offset of the TextSelection
  /// is before or at the mistake offset
  bool isBaseBeforeOrAtMistake(Mistake mistake) =>
      base.offset <= mistake.offset;

  /// Checks if the TextSelection is within the boundaries of the mistake
  bool isWithinMistake(Mistake mistake) =>
      (end > mistake.offset && end <= mistake.endOffset) ||
      (start > mistake.offset && start <= mistake.endOffset);

  /// Checks if the base offset of the TextSelection
  /// is within the mistake boundaries
  bool isBaseWithinAndAtMistakeBoundaries(Mistake mistake) =>
      base.offset >= mistake.offset && base.offset <= mistake.endOffset;

  /// Checks if the TextSelection encompasses the entire mistake
  bool isEncompassingMistake(Mistake mistake) =>
      start <= mistake.offset && end >= mistake.endOffset;
}
