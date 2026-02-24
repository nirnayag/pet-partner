import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void navigateToOtp() {
    _navigationService.navigateToVerifyOtpView();
  }

  void navigateToSignUp() {
    _navigationService.navigateToRegisterView();
  }

  void goBack() {
    _navigationService.back();
  }
}
