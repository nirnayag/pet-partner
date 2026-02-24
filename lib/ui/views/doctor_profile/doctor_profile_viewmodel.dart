import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:partner/app/app.locator.dart';

class DoctorProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  bool _isEmailAlertsEnabled = false;
  bool get isEmailAlertsEnabled => _isEmailAlertsEnabled;

  bool _isInAppAlertsEnabled = true;
  bool get isInAppAlertsEnabled => _isInAppAlertsEnabled;

  bool _isSmsUpdatesEnabled = false;
  bool get isSmsUpdatesEnabled => _isSmsUpdatesEnabled;

  void toggleEmailAlerts(bool value) {
    _isEmailAlertsEnabled = value;
    notifyListeners();
  }

  void toggleInAppAlerts(bool value) {
    _isInAppAlertsEnabled = value;
    notifyListeners();
  }

  void toggleSmsUpdates(bool value) {
    _isSmsUpdatesEnabled = value;
    notifyListeners();
  }

  void goBack() {
    _navigationService.back();
  }

  void logout() {
    // TODO: Implement logout logic
    _navigationService.clearStackAndShow('/login-view');
  }
}
