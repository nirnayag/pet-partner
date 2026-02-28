/// Result of sending pending reminders.
class SendResult {
  /// Creates a [SendResult].
  const SendResult({
    required this.total,
    required this.sent,
    required this.failed,
    required this.errors,
  });

  /// Parses a [SendResult] from JSON.
  factory SendResult.fromJson(
    Map<String, dynamic> json,
  ) {
    return SendResult(
      total: json['total'] as int,
      sent: json['sent'] as int,
      failed: json['failed'] as int,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          <String>[],
    );
  }

  /// Total number of reminders processed.
  final int total;

  /// Number of reminders sent successfully.
  final int sent;

  /// Number of failed sends.
  final int failed;

  /// Error messages for failed sends.
  final List<String> errors;
}
