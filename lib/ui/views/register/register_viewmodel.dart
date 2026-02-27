import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RegisterViewModel extends BaseViewModel {
  final _navigationService =
      locator<NavigationService>();

  void navigateToOtp() {
    _navigationService.navigateToVerifyOtpView();
  }

  void navigateToLogin() {
    _navigationService.navigateToLoginView();
  }

  void goBack() {
    _navigationService.back<dynamic>();
  }
}
