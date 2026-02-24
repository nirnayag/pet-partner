import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:partner/app/app.locator.dart';

class PatientProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void goBack() {
    _navigationService.back();
  }
}
