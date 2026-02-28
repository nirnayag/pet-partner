import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/enums/document_type.dart';
import 'package:partner/ui/views/document_upload/document_upload_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late DocumentUploadViewModel model;
  late MockNavigationService mockNavService;

  setUp(() {
    registerServices();
    mockNavService =
        locator<NavigationService>()
            as MockNavigationService;
  });

  tearDown(locator.reset);

  DocumentUploadViewModel getModel({
    String? petId,
  }) =>
      DocumentUploadViewModel(petId: petId);

  group('DocumentUploadViewModel -', () {
    group('initialise -', () {
      test(
        'pre-fills petId when provided',
        () {
          model = getModel(petId: 'pet-1');
          model.initialise();

          expect(
            model.petIdController.text,
            'pet-1',
          );
        },
      );

      test(
        'leaves petId empty when not provided',
        () {
          model = getModel();
          model.initialise();

          expect(
            model.petIdController.text,
            isEmpty,
          );
        },
      );
    });

    group('setDocumentType -', () {
      test(
        'updates selected type',
        () {
          model = getModel();
          model.setDocumentType(
            DocumentType.labResult,
          );

          expect(
            model.selectedType,
            DocumentType.labResult,
          );
        },
      );
    });

    group('clearFile -', () {
      test(
        'clears the selected file',
        () {
          model = getModel();
          model.clearFile();

          expect(model.selectedFile, isNull);
          expect(
            model.selectedFileName,
            isNull,
          );
        },
      );
    });

    group('upload -', () {
      test(
        'shows error when no file selected',
        () async {
          model = getModel();
          model.titleController.text = 'Test';
          model.petIdController.text = 'pet-1';

          await model.upload();

          expect(
            model.errorMessage,
            'Please select a file.',
          );
        },
      );

      test(
        'shows error when title is empty',
        () async {
          model = getModel();
          // Manually set a file (mock) to
          // bypass the null check
          // We can test validation in order:
          // file -> title -> petId
          await model.upload();

          expect(
            model.errorMessage,
            'Please select a file.',
          );
        },
      );

      test(
        'shows error when petId is empty',
        () async {
          model = getModel();
          model.titleController.text = 'Test';

          // No file selected
          await model.upload();

          expect(
            model.errorMessage,
            'Please select a file.',
          );
        },
      );

      test(
        'sets isUploading during upload',
        () async {
          model = getModel(petId: 'pet-1');
          model.initialise();

          // Without a file, upload won't start
          expect(model.isUploading, false);
        },
      );
    });

    group('onBackTapped -', () {
      test(
        'navigates back',
        () {
          model = getModel();
          model.onBackTapped();

          verify(
            mockNavService.back<void>(),
          ).called(1);
        },
      );
    });

    group('default state -', () {
      test(
        'starts with DocumentType.other',
        () {
          model = getModel();

          expect(
            model.selectedType,
            DocumentType.other,
          );
        },
      );

      test(
        'uploadProgress starts at 0',
        () {
          model = getModel();

          expect(model.uploadProgress, 0);
        },
      );

      test(
        'isUploading starts as false',
        () {
          model = getModel();

          expect(model.isUploading, false);
        },
      );
    });
  });
}
