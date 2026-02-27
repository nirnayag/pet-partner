/// Enum representing the type of a clinic reminder.
enum ReminderType {
  /// Reminder for an upcoming appointment.
  appointment('appointment'),

  /// Reminder for a vaccination due date.
  vaccination('vaccination'),

  /// Reminder for medication administration.
  medication('medication'),

  /// Reminder for a routine checkup.
  checkup('checkup'),

  /// Reminder for a grooming session.
  grooming('grooming'),

  /// Reminder for deworming treatment.
  deworming('deworming'),

  /// Custom reminder created by clinic staff.
  custom('custom');

  const ReminderType(this.value);

  /// The API string value for this reminder type.
  final String value;

  /// Parses a type string from the API into a
  /// [ReminderType].
  ///
  /// Throws [ArgumentError] if [type] does not match any
  /// known value.
  static ReminderType fromString(String type) {
    return ReminderType.values.firstWhere(
      (e) => e.value == type,
      orElse: () => throw ArgumentError(
        'Unknown reminder type: $type',
      ),
    );
  }

  /// Human-readable label for display in the UI.
  String get displayName {
    switch (this) {
      case ReminderType.appointment:
        return 'Appointment';
      case ReminderType.vaccination:
        return 'Vaccination';
      case ReminderType.medication:
        return 'Medication';
      case ReminderType.checkup:
        return 'Checkup';
      case ReminderType.grooming:
        return 'Grooming';
      case ReminderType.deworming:
        return 'Deworming';
      case ReminderType.custom:
        return 'Custom';
    }
  }
}
