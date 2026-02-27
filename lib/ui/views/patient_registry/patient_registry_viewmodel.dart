import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PatientRegistryViewModel extends BaseViewModel {
  final _navigationService =
      locator<NavigationService>();

  void navigateToHomeView() {
    _navigationService
        .clearStackAndShow<void>(Routes.homeView);
  }

  void navigateToScheduleView() {
    _navigationService.clearStackAndShow<void>(
      Routes.scheduleView,
    );
  }

  void navigateToPatientRegistryView() {
    // Current view
  }

  void navigateToPatientProfileView() {
    _navigationService
        .navigateToPatientProfileView();
  }
}
