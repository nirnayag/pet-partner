import 'package:stacked/stacked.dart';

/// Reactive service that manages bottom navigation
/// state across the app.
///
/// Any ViewModel can listen to index changes by
/// including this in `listenableServices`.
class LayoutService with ListenableServiceMixin {
  int _currentIndex = 0;

  /// The currently selected bottom navigation index.
  int get currentIndex => _currentIndex;

  /// Updates the selected tab index and notifies
  /// listeners.
  void setIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  /// Resets the tab index back to the home tab.
  void resetIndex() {
    _currentIndex = 0;
    notifyListeners();
  }
}
