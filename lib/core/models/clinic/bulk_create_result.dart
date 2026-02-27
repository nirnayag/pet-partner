/// Result of a bulk user creation operation.
class BulkCreateResult {
  /// Creates a [BulkCreateResult].
  const BulkCreateResult({
    required this.total,
    required this.successful,
    required this.failed,
    required this.results,
  });

  /// Parses a [BulkCreateResult] from JSON.
  factory BulkCreateResult.fromJson(
    Map<String, dynamic> json,
  ) {
    return BulkCreateResult(
      total: json['total'] as int,
      successful: json['successful'] as int,
      failed: json['failed'] as int,
      results: (json['results'] as List<dynamic>)
          .map(
            (e) => e as Map<String, dynamic>,
          )
          .toList(),
    );
  }

  /// Total number of users attempted.
  final int total;

  /// Number of successfully created users.
  final int successful;

  /// Number of failed creations.
  final int failed;

  /// Per-user results with details.
  final List<Map<String, dynamic>> results;
}
