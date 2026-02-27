import 'package:partner/app/app.bottomsheets.dart';
import 'package:partner/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AppointmentDetailViewModel
    extends BaseViewModel {
  final _navigationService =
      locator<NavigationService>();
  final _bottomSheetService =
      locator<BottomSheetService>();

  void goBack() {
    _navigationService.back<void>();
  }

  void showMedicalRecordSheet() {
    _bottomSheetService.showCustomSheet<void, void>(
      variant: BottomSheetType.medicalRecord,
    );
  }
}
