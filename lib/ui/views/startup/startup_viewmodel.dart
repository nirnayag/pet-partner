import 'dart:async';

import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService =
      locator<NavigationService>();

  Future<void> runStartupLogic() async {
    await Future<void>.delayed(
      const Duration(seconds: 3),
    );

    unawaited(
      _navigationService.replaceWithLoginView(),
    );
  }
}
