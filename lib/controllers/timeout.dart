import 'dart:async';

import 'package:flutter/material.dart';

/// This class allows us to execute
/// callback functions with the time gap between them,

class Timeout {
  /// Timegap between callbacks
  final Duration duration;

  Timer? _internalTimer;

  /// Constructor
  Timeout(this.duration);

  /// Runs the required action
  void run(VoidCallback action) {
    if (_internalTimer != null && !_internalTimer!.isActive) {
      action.call();
      _internalTimer = Timer(
        duration,
        () {},
      );
    } else {
      _internalTimer = Timer(
        duration,
        () {
          action.call();
        },
      );
    }
  }
}
