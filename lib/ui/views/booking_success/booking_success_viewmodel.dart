import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the booking success
/// confirmation screen.
class BookingSuccessViewmodel
    extends BaseViewModel {
  /// Creates a [BookingSuccessViewmodel].
  BookingSuccessViewmodel({
    required this.appointment,
  });

  /// The newly created appointment.
  final Appointment appointment;

  final _navigationService =
      locator<NavigationService>();

  /// Navigates back to the main/home view and
  /// clears the navigation stack.
  void goToHome() {
    _navigationService.clearStackAndShow<void>(
      Routes.mainView,
    );
  }

  /// Navigates to the appointment detail view
  /// for the booked appointment.
  void viewAppointment() {
    _navigationService.navigateTo<void>(
      Routes.appointmentDetailView,
    );
  }
}
