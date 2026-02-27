import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class VerifyOtpViewModel extends BaseViewModel {
  final _navigationService =
      locator<NavigationService>();

  void verifyOtp(String pin) {
    // Implement verification logic
    _navigationService.replaceWithHomeView();
  }

  void goBack() {
    _navigationService.back<dynamic>();
  }
}
