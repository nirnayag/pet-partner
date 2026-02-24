import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';

class ScheduleViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void goBack() {
    _navigationService.back();
  }

  void navigateToAppointmentDetail() {
    _navigationService.navigateToAppointmentDetailView();
  }

  void navigateToPatientRegistryView() {
    _navigationService.clearStackAndShow(Routes.patientRegistryView);
  }

  void navigateToHomeView() {
    _navigationService.clearStackAndShow(Routes.homeView);
  }
}
