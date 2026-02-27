import 'package:partner/core/enums/reminder_type.dart';

/// A scheduled reminder for a clinic event.
class Reminder {
  /// Creates a [Reminder].
  const Reminder({
    required this.id,
    required this.clinicId,
    required this.reminderType,
    required this.title,
    required this.scheduledFor,
    required this.status,
    required this.createdAt,
    this.petId,
    this.ownerId,
    this.appointmentId,
    this.message,
    this.channels,
    this.metadata,
  });

  /// Parses a [Reminder] from JSON.
  factory Reminder.fromJson(
    Map<String, dynamic> json,
  ) {
    return Reminder(
      id: json['id'] as String,
      clinicId: json['clinicId'] as String,
      reminderType: ReminderType.fromString(
        json['reminderType'] as String,
      ),
      title: json['title'] as String,
      scheduledFor: DateTime.parse(
        json['scheduledFor'] as String,
      ),
      status: json['status'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      petId: json['petId'] as String?,
      ownerId: json['ownerId'] as String?,
      appointmentId:
          json['appointmentId'] as String?,
      message: json['message'] as String?,
      channels: (json['channels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      metadata:
          json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Unique identifier.
  final String id;

  /// The clinic this reminder belongs to.
  final String clinicId;

  /// The pet this reminder is for (if applicable).
  final String? petId;

  /// The pet owner to notify (if applicable).
  final String? ownerId;

  /// The related appointment (if applicable).
  final String? appointmentId;

  /// The type of reminder.
  final ReminderType reminderType;

  /// Short title displayed in notifications.
  final String title;

  /// Body text of the reminder.
  final String? message;

  /// Scheduled date and time for delivery.
  final DateTime scheduledFor;

  /// Current status (e.g. "pending", "sent").
  final String status;

  /// Delivery channels (e.g. "sms", "push").
  final List<String>? channels;

  /// Arbitrary key-value metadata.
  final Map<String, dynamic>? metadata;

  /// Timestamp when the reminder was created.
  final DateTime createdAt;

  /// Serialises this reminder back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'clinicId': clinicId,
      'reminderType': reminderType.value,
      'title': title,
      'scheduledFor':
          scheduledFor.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      if (petId != null) 'petId': petId,
      if (ownerId != null) 'ownerId': ownerId,
      if (appointmentId != null)
        'appointmentId': appointmentId,
      if (message != null) 'message': message,
      if (channels != null) 'channels': channels,
      if (metadata != null) 'metadata': metadata,
    };
  }
}
