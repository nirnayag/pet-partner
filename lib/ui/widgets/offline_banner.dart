import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/services/connectivity_service.dart';
import 'package:stacked/stacked.dart';

/// A banner that appears at the top of the screen
/// when the device is offline.
///
/// Wraps a [ConnectivityService] listener to
/// auto-show and auto-hide.
class OfflineBanner
    extends ViewModelWidget<OfflineBannerModel> {
  /// Creates an [OfflineBanner].
  const OfflineBanner({super.key});

  @override
  Widget build(
    BuildContext context,
    OfflineBannerModel viewModel,
  ) {
    if (viewModel.isConnected) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      color: Colors.red.shade700,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'No internet connection',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// ViewModel for the [OfflineBanner].
class OfflineBannerModel
    extends ReactiveViewModel {
  final _connectivityService =
      locator<ConnectivityService>();

  /// Whether the device is connected.
  bool get isConnected =>
      _connectivityService.isConnected;

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [_connectivityService];
}
