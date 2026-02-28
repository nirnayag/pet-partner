import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:stacked/stacked.dart';

/// Monitors network connectivity changes.
///
/// Exposes [isConnected] and a reactive notification
/// so views can show/hide an offline banner.
class ConnectivityService
    with ListenableServiceMixin {
  /// Creates a [ConnectivityService].
  ConnectivityService() {
    listenToReactiveValues([_isConnected]);
  }

  final _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>?
      _subscription;

  final ReactiveValue<bool> _isConnected =
      ReactiveValue<bool>(true);

  /// Whether the device currently has connectivity.
  bool get isConnected => _isConnected.value;

  /// Initialises the connectivity listener.
  ///
  /// Call once during app startup.
  Future<void> init() async {
    final result =
        await _connectivity.checkConnectivity();
    _isConnected.value = _hasConnection(result);

    _subscription = _connectivity
        .onConnectivityChanged
        .listen((result) {
      _isConnected.value = _hasConnection(result);
      notifyListeners();
    });
  }

  /// Checks connectivity on demand.
  Future<bool> checkConnectivity() async {
    final result =
        await _connectivity.checkConnectivity();
    _isConnected.value = _hasConnection(result);
    notifyListeners();
    return _isConnected.value;
  }

  bool _hasConnection(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }

  /// Stops listening for connectivity changes.
  void dispose() {
    _subscription?.cancel();
  }
}
