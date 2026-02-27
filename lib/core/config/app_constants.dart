class AppConstants {
  // Snackbar
  static const Duration snackbarDuration =
      Duration(seconds: 3);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File upload
  static const int maxFileSizeBytes =
      5 * 1024 * 1024; // 5 MB
  static const List<String> supportedImageTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
  ];

  // Search
  static const int searchDebounceMs = 300;

  // Presigned URL
  static const int presignedUrlExpirySeconds = 300; // 5 min
}
