/// Enum representing the lifecycle status of an
/// appointment.
enum AppointmentStatus {
  /// Awaiting confirmation.
  pending('pending'),

  /// Confirmed and scheduled.
  scheduled('scheduled'),

  /// Confirmed by the pet owner or clinic.
  confirmed('confirmed'),

  /// Pet owner has arrived and checked in.
  checkedIn('checked_in'),

  /// Appointment is currently underway.
  inProgress('in_progress'),

  /// Appointment has been completed.
  completed('completed'),

  /// Appointment was cancelled.
  cancelled('cancelled'),

  /// Pet owner did not show up.
  noShow('no_show');

  const AppointmentStatus(this.value);

  /// The API string value for this status.
  final String value;

  /// Parses a status string from the API into an
  /// [AppointmentStatus].
  ///
  /// Throws [ArgumentError] if [status] does not match
  /// any known value.
  static AppointmentStatus fromString(String status) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => throw ArgumentError(
        'Unknown status: $status',
      ),
    );
  }

  /// Human-readable label for display in the UI.
  String get displayName {
    switch (this) {
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.checkedIn:
        return 'Checked In';
      case AppointmentStatus.inProgress:
        return 'In Progress';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No Show';
    }
  }
}
