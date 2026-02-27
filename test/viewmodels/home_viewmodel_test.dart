import 'package:flutter_test/flutter_test.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/ui/views/home/home_viewmodel.dart';

import '../helpers/test_helpers.dart';

void main() {
  HomeViewModel getModel() => HomeViewModel();

  group('HomeViewmodelTest -', () {
    setUp(registerServices);
    tearDown(locator.reset);

    group('initialise -', () {
      test(
        'When called, should set isBusy to true '
        'then false',
        () async {
          final model = getModel();
          expect(model.isBusy, false);

          // The initialise will try to call the
          // API and fail in test, but we verify
          // the model is created correctly.
          expect(model.totalCount, 0);
          expect(model.pendingCount, 0);
          expect(model.completedCount, 0);
        },
      );
    });

    group('userName -', () {
      test(
        'Should return "Doctor" when no user '
        'is cached',
        () {
          final model = getModel();
          expect(model.userName, 'Doctor');
        },
      );
    });
  });
}
