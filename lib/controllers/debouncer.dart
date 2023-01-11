import 'dart:async';

import 'package:flutter/material.dart';

/// Debouncer class, which will perform an action after the predefined time gap;
class Debouncer {
  /// Number of milliseconds for the delay
  final int milliseconds;

  Timer? _timer;

  /// Constructor
  Debouncer({required this.milliseconds});

  /// Runs the action
  void run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
