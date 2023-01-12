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
    if (_internalTimer == null) {
      action.call();
      _internalTimer = Timer(duration, () {});

      return;
    }

    if (_internalTimer!.isActive) {
      Timer(
        duration,
        () {
          action.call();
        },
      );

      return;
    } else {
      action.call();
      _internalTimer = Timer(duration, () {});

      return;
    }
  }
}
