import 'package:partner/core/enums/appointment_status.dart';
import 'package:partner/core/models/auth/user.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/core/models/pet_owner.dart';

/// A clinic appointment.
class Appointment {
  /// Creates an [Appointment].
  const Appointment({
    required this.id,
    required this.clinicId,
    required this.petId,
    required this.title,
    required this.status,
    required this.scheduledStart,
    required this.scheduledEnd,
    this.ownerId,
    this.veterinarianId,
    this.description,
    this.appointmentType,
    this.durationMinutes,
    this.roomNumber,
    this.preAppointmentNotes,
    this.postAppointmentNotes,
    this.actualStart,
    this.actualEnd,
    this.cancelledBy,
    this.cancelledAt,
    this.cancellationReason,
    this.pet,
    this.owner,
    this.veterinarian,
  });

  /// Parses an [Appointment] from JSON.
  factory Appointment.fromJson(
    Map<String, dynamic> json,
  ) {
    return Appointment(
      id: json['id'] as String,
      clinicId: json['clinicId'] as String,
      petId: json['petId'] as String,
      title: json['title'] as String,
      status: AppointmentStatus.fromString(
        json['status'] as String,
      ),
      scheduledStart: DateTime.parse(
        json['scheduledStart'] as String,
      ),
      scheduledEnd: DateTime.parse(
        json['scheduledEnd'] as String,
      ),
      ownerId: json['ownerId'] as String?,
      veterinarianId:
          json['veterinarianId'] as String?,
      description: json['description'] as String?,
      appointmentType:
          json['appointmentType'] as String?,
      durationMinutes:
          json['durationMinutes'] as int?,
      roomNumber: json['roomNumber'] as String?,
      preAppointmentNotes:
          json['preAppointmentNotes'] as String?,
      postAppointmentNotes:
          json['postAppointmentNotes'] as String?,
      actualStart: json['actualStart'] != null
          ? DateTime.parse(
              json['actualStart'] as String,
            )
          : null,
      actualEnd: json['actualEnd'] != null
          ? DateTime.parse(
              json['actualEnd'] as String,
            )
          : null,
      cancelledBy: json['cancelledBy'] as String?,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(
              json['cancelledAt'] as String,
            )
          : null,
      cancellationReason:
          json['cancellationReason'] as String?,
      pet: json['pet'] != null
          ? Pet.fromJson(
              json['pet'] as Map<String, dynamic>,
            )
          : null,
      owner: json['owner'] != null
          ? PetOwner.fromJson(
              json['owner'] as Map<String, dynamic>,
            )
          : null,
      veterinarian: json['veterinarian'] != null
          ? User.fromJson(
              json['veterinarian']
                  as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Unique identifier.
  final String id;

  /// Clinic this appointment belongs to.
  final String clinicId;

  /// The pet being seen.
  final String petId;

  /// The pet owner's ID.
  final String? ownerId;

  /// The assigned veterinarian's ID.
  final String? veterinarianId;

  /// Short title / reason for the visit.
  final String title;

  /// Detailed description.
  final String? description;

  /// Type of appointment (e.g. "checkup").
  final String? appointmentType;

  /// Current lifecycle status.
  final AppointmentStatus status;

  /// Scheduled start time.
  final DateTime scheduledStart;

  /// Scheduled end time.
  final DateTime scheduledEnd;

  /// Expected duration in minutes.
  final int? durationMinutes;

  /// Room or exam-room number.
  final String? roomNumber;

  /// Notes added before the appointment.
  final String? preAppointmentNotes;

  /// Notes added after the appointment.
  final String? postAppointmentNotes;

  /// Actual start time (when checked in).
  final DateTime? actualStart;

  /// Actual end time (when completed).
  final DateTime? actualEnd;

  /// User ID of whoever cancelled.
  final String? cancelledBy;

  /// Timestamp when cancelled.
  final DateTime? cancelledAt;

  /// Reason for cancellation.
  final String? cancellationReason;

  /// Nested pet details.
  final Pet? pet;

  /// Nested pet-owner details.
  final PetOwner? owner;

  /// Nested veterinarian details.
  final User? veterinarian;

  /// Serialises this appointment back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'clinicId': clinicId,
      'petId': petId,
      'title': title,
      'status': status.value,
      'scheduledStart':
          scheduledStart.toIso8601String(),
      'scheduledEnd':
          scheduledEnd.toIso8601String(),
      if (ownerId != null) 'ownerId': ownerId,
      if (veterinarianId != null)
        'veterinarianId': veterinarianId,
      if (description != null)
        'description': description,
      if (appointmentType != null)
        'appointmentType': appointmentType,
      if (durationMinutes != null)
        'durationMinutes': durationMinutes,
      if (roomNumber != null)
        'roomNumber': roomNumber,
      if (preAppointmentNotes != null)
        'preAppointmentNotes': preAppointmentNotes,
      if (postAppointmentNotes != null)
        'postAppointmentNotes': postAppointmentNotes,
      if (actualStart != null)
        'actualStart':
            actualStart!.toIso8601String(),
      if (actualEnd != null)
        'actualEnd': actualEnd!.toIso8601String(),
      if (cancelledBy != null)
        'cancelledBy': cancelledBy,
      if (cancelledAt != null)
        'cancelledAt':
            cancelledAt!.toIso8601String(),
      if (cancellationReason != null)
        'cancellationReason': cancellationReason,
      if (pet != null) 'pet': pet!.toJson(),
      if (owner != null) 'owner': owner!.toJson(),
      if (veterinarian != null)
        'veterinarian': veterinarian!.toJson(),
    };
  }
}
