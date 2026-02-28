import 'package:partner/core/enums/reminder_type.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/core/models/pet_owner.dart';

/// A scheduled reminder for a clinic event.
class Reminder {
  /// Creates a [Reminder].
  const Reminder({
    required this.id,
    required this.reminderType,
    required this.title,
    required this.scheduledFor,
    required this.status,
    required this.channels,
    required this.createdAt,
    required this.updatedAt,
    this.petId,
    this.ownerId,
    this.appointmentId,
    this.message,
    this.metadata,
    this.pet,
    this.owner,
  });

  /// Parses a [Reminder] from JSON.
  factory Reminder.fromJson(
    Map<String, dynamic> json,
  ) {
    return Reminder(
      id: json['id'] as String,
      reminderType: ReminderType.fromString(
        json['reminderType'] as String,
      ),
      title: json['title'] as String,
      scheduledFor: DateTime.parse(
        json['scheduledFor'] as String,
      ),
      status: json['status'] as String,
      channels:
          (json['channels'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              <String>[],
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),
      petId: json['petId'] as String?,
      ownerId: json['ownerId'] as String?,
      appointmentId:
          json['appointmentId'] as String?,
      message: json['message'] as String?,
      metadata: json['metadata']
          as Map<String, dynamic>?,
      pet: json['pet'] != null
          ? Pet.fromJson(
              json['pet']
                  as Map<String, dynamic>,
            )
          : null,
      owner: json['owner'] != null
          ? PetOwner.fromJson(
              json['owner']
                  as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Unique identifier.
  final String id;

  /// The pet this reminder is for.
  final String? petId;

  /// The pet owner to notify.
  final String? ownerId;

  /// The related appointment.
  final String? appointmentId;

  /// The type of reminder.
  final ReminderType reminderType;

  /// Short title displayed in notifications.
  final String title;

  /// Body text of the reminder.
  final String? message;

  /// Scheduled date and time for delivery.
  final DateTime scheduledFor;

  /// Current status: pending, sent, failed.
  final String status;

  /// Delivery channels (e.g. sms, push, email).
  final List<String> channels;

  /// Arbitrary key-value metadata.
  final Map<String, dynamic>? metadata;

  /// Nested pet object (when included).
  final Pet? pet;

  /// Nested owner object (when included).
  final PetOwner? owner;

  /// Timestamp when the reminder was created.
  final DateTime createdAt;

  /// Timestamp when the reminder was last
  /// updated.
  final DateTime updatedAt;

  /// Serialises this reminder back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'reminderType': reminderType.value,
      'title': title,
      'scheduledFor':
          scheduledFor.toIso8601String(),
      'status': status,
      'channels': channels,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (petId != null) 'petId': petId,
      if (ownerId != null) 'ownerId': ownerId,
      if (appointmentId != null)
        'appointmentId': appointmentId,
      if (message != null) 'message': message,
      if (metadata != null) 'metadata': metadata,
    };
  }
}
