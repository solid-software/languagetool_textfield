import 'dart:async';

import 'package:flutter/material.dart';

/// A utility class that helps debounce function calls by delaying the execution
/// of an action until a specified duration has passed without any new calls.
class Debouncer {
  /// The duration in milliseconds for which the debouncer should wait
  final int milliseconds;

  /// Timer instance used to manage the debounce behavior
  Timer? _timer;

  /// Creates a new instance of the Debouncer with the specified [milliseconds]
  Debouncer({required this.milliseconds});

  /// Runs the [action] after the specified debounce [milliseconds]
  void run(VoidCallback action) {
    // Cancel any previously scheduled timer
    _timer?.cancel();

    // Schedule a new timer that executes the [action]
    // after the specified duration
    _timer = Timer(Duration(milliseconds: milliseconds), () {
      action.call();
    });
  }
}
