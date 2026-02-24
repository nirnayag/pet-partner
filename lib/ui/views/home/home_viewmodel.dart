import 'package:partner/app/app.bottomsheets.dart';
import 'package:partner/app/app.dialogs.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:partner/app/app.router.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _navigationService = locator<NavigationService>();

  void navigateToScheduleView() {
    _navigationService.navigateToScheduleView();
  }

  void navigateToAppointmentDetail() {
    _navigationService.navigateToAppointmentDetailView();
  }

  void navigateToPatientRegistryView() {
    _navigationService.clearStackAndShow(Routes.patientRegistryView);
  }

  void navigateToDoctorProfileView() {
    _navigationService.navigateToDoctorProfileView();
  }

  String get counterLabel => 'Counter is: $_counter';

  int _counter = 0;

  void incrementCounter() {
    _counter++;
    rebuildUi();
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked $_counter stars on Github',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }
}
