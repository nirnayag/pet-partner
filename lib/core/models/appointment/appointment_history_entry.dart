/// A single entry in an appointment's audit history.
class AppointmentHistoryEntry {
  /// Creates an [AppointmentHistoryEntry].
  const AppointmentHistoryEntry({
    required this.id,
    required this.action,
    required this.timestamp,
    this.performedBy,
    this.changes,
  });

  /// Parses an [AppointmentHistoryEntry] from JSON.
  factory AppointmentHistoryEntry.fromJson(
    Map<String, dynamic> json,
  ) {
    return AppointmentHistoryEntry(
      id: json['id'] as String,
      action: json['action'] as String,
      timestamp: DateTime.parse(
        json['timestamp'] as String,
      ),
      performedBy: json['performedBy'] as String?,
      changes: json['changes'] != null
          ? json['changes'] as Map<String, dynamic>
          : null,
    );
  }

  /// Unique identifier.
  final String id;

  /// The action that was performed (e.g. "created",
  /// "status_changed", "updated").
  final String action;

  /// User ID of who performed the action.
  final String? performedBy;

  /// When the action occurred.
  final DateTime timestamp;

  /// Field-level changes made in this action.
  final Map<String, dynamic>? changes;

  /// Serialises this entry back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'action': action,
      'timestamp': timestamp.toIso8601String(),
      if (performedBy != null)
        'performedBy': performedBy,
      if (changes != null) 'changes': changes,
    };
  }
}
