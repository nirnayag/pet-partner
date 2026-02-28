import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/services/api_client.dart';

/// Handles image picking, cropping, and upload via
/// presigned S3 URLs.
class ImageUploadService {
  final _apiClient = locator<ApiClient>();
  final _picker = ImagePicker();

  /// Picks an image from [source] and optionally
  /// crops it.
  ///
  /// Returns the processed [File] or `null` if the
  /// user cancelled.
  Future<File?> pickAndCropImage({
    required ImageSource source,
    double maxWidth = 1024,
    double maxHeight = 1024,
    CropAspectRatio? aspectRatio,
  }) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: 85,
    );
    if (picked == null) return null;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: aspectRatio,
      compressQuality: 85,
      maxWidth: maxWidth.toInt(),
      maxHeight: maxHeight.toInt(),
    );
    if (cropped == null) return null;

    return File(cropped.path);
  }

  /// Uploads a pet photo using the presigned URL flow.
  ///
  /// 1. Gets a presigned URL from the API
  /// 2. Uploads the file to S3
  /// 3. Confirms the upload
  ///
  /// Returns the final photo URL.
  Future<String> uploadPetPhoto(
    String petId,
    File imageFile,
  ) async {
    final fileName = imageFile.path.split('/').last;
    final contentType = _contentTypeForFile(fileName);
    final bytes = await imageFile.readAsBytes();

    // 1. Get presigned URL.
    final presignedBody = await _apiClient.post(
      '/api/pets/$petId/photo/presigned-url',
      data: <String, dynamic>{
        'contentType': contentType,
        'fileName': fileName,
        'fileSize': bytes.length,
      },
    ) as Map<String, dynamic>;
    final presignedData =
        presignedBody['data'] as Map<String, dynamic>;
    final uploadUrl =
        presignedData['uploadUrl'] as String;
    final photoUrl =
        presignedData['photoUrl'] as String;

    // 2. Upload to S3.
    await _uploadToS3(
      uploadUrl: uploadUrl,
      bytes: bytes,
      contentType: contentType,
    );

    // 3. Confirm.
    final confirmBody = await _apiClient.patch(
      '/api/pets/$petId/photo',
      data: <String, dynamic>{
        'photoUrl': photoUrl,
      },
    ) as Map<String, dynamic>;
    final confirmData =
        confirmBody['data'] as Map<String, dynamic>;

    return confirmData['photoUrl'] as String;
  }

  /// Uploads a user avatar using the presigned URL flow.
  ///
  /// Returns the final avatar URL.
  Future<String> uploadAvatar(File imageFile) async {
    final fileName = imageFile.path.split('/').last;
    final contentType = _contentTypeForFile(fileName);
    final bytes = await imageFile.readAsBytes();

    // 1. Get presigned URL.
    final presignedBody = await _apiClient.post(
      '/api/profile/avatar/presigned-url',
      data: <String, dynamic>{
        'contentType': contentType,
        'fileName': fileName,
        'fileSize': bytes.length,
      },
    ) as Map<String, dynamic>;
    final presignedData =
        presignedBody['data'] as Map<String, dynamic>;
    final uploadUrl =
        presignedData['uploadUrl'] as String;
    final photoUrl =
        presignedData['photoUrl'] as String;

    // 2. Upload to S3.
    await _uploadToS3(
      uploadUrl: uploadUrl,
      bytes: bytes,
      contentType: contentType,
    );

    // 3. Confirm.
    final confirmBody = await _apiClient.patch(
      '/api/profile/avatar',
      data: <String, dynamic>{
        'photoUrl': photoUrl,
      },
    ) as Map<String, dynamic>;
    final confirmData =
        confirmBody['data'] as Map<String, dynamic>;

    return confirmData['avatarUrl'] as String;
  }

  Future<void> _uploadToS3({
    required String uploadUrl,
    required List<int> bytes,
    required String contentType,
  }) async {
    final plainDio = Dio();
    await plainDio.put<void>(
      uploadUrl,
      data: Stream.fromIterable(
        bytes.map((b) => [b]),
      ),
      options: Options(
        headers: <String, dynamic>{
          Headers.contentTypeHeader: contentType,
          Headers.contentLengthHeader: bytes.length,
        },
      ),
    );
  }

  String _contentTypeForFile(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
