import 'dart:async';
import 'dart:ui';

/// A simple debouncer that delays execution of an
/// action until a pause in calls.
class Debouncer {
  /// Creates a [Debouncer] with the given delay.
  Debouncer({required this.milliseconds});

  /// The debounce delay in milliseconds.
  final int milliseconds;

  Timer? _timer;

  /// Schedules [action] to run after the debounce
  /// delay. Cancels any previously scheduled action.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(
      Duration(milliseconds: milliseconds),
      action,
    );
  }

  /// Cancels any pending action.
  void dispose() {
    _timer?.cancel();
  }
}
