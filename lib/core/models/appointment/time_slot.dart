/// A single availability time slot returned by the
/// scheduling API.
class TimeSlot {
  /// Creates a [TimeSlot].
  const TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
  });

  /// Parses a [TimeSlot] from JSON.
  factory TimeSlot.fromJson(
    Map<String, dynamic> json,
  ) {
    return TimeSlot(
      startTime: DateTime.parse(
        json['startTime'] as String,
      ),
      endTime: DateTime.parse(
        json['endTime'] as String,
      ),
      isAvailable: json['isAvailable'] as bool,
    );
  }

  /// The beginning of the slot.
  final DateTime startTime;

  /// The end of the slot.
  final DateTime endTime;

  /// Whether this slot is open for booking.
  final bool isAvailable;

  /// Serialises this time slot back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isAvailable': isAvailable,
    };
  }
}
