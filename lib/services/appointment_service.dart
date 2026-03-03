import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:partner/core/models/appointment/appointment_history_entry.dart';
import 'package:partner/core/models/appointment/time_slot.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/services/api_client.dart';

/// Handles appointment-related API calls.
class AppointmentService {
  final _apiClient = locator<ApiClient>();

  /// Fetches a paginated list of appointments.
  ///
  /// Supports optional filters for [status], [petId],
  /// [veterinarianId], and [date].
  Future<PaginatedResponse<Appointment>> getAppointments({
    int page = 1,
    int limit = 20,
    String? status,
    String? petId,
    String? veterinarianId,
    String? date,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
      if (petId != null) 'petId': petId,
      if (veterinarianId != null)
        'veterinarianId': veterinarianId,
      if (date != null) ...{
        'startDate': '${date}T00:00:00.000Z',
        'endDate': '${date}T23:59:59.999Z',
      },
    };

    final body = await _apiClient.get(
      ApiConfig.appointmentsEndpoint,
      queryParameters: queryParams,
    ) as Map<String, dynamic>;

    return PaginatedResponse<Appointment>.fromJson(
      body['data'] as Map<String, dynamic>,
      Appointment.fromJson,
    );
  }

  /// Fetches a single appointment by
  /// [appointmentId].
  Future<Appointment> getAppointmentById(
    String appointmentId,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.appointmentByIdEndpoint(
        appointmentId,
      ),
    ) as Map<String, dynamic>;

    return Appointment.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Creates a new appointment.
  Future<Appointment> createAppointment(
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.post(
      ApiConfig.appointmentsEndpoint,
      data: data,
    ) as Map<String, dynamic>;

    return Appointment.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Updates an existing appointment.
  Future<Appointment> updateAppointment(
    String appointmentId,
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.appointmentByIdEndpoint(
        appointmentId,
      ),
      data: data,
    ) as Map<String, dynamic>;

    return Appointment.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Updates only the status of an appointment.
  Future<Appointment> updateAppointmentStatus(
    String appointmentId,
    String status,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.appointmentStatusEndpoint(
        appointmentId,
      ),
      data: <String, dynamic>{'status': status},
    ) as Map<String, dynamic>;

    return Appointment.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Approves a pending appointment.
  Future<Appointment> approveAppointment(
    String appointmentId,
  ) async {
    final body = await _apiClient.post(
      ApiConfig.appointmentApproveEndpoint(
        appointmentId,
      ),
    ) as Map<String, dynamic>;

    return Appointment.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Fetches appointments with a pending status.
  Future<PaginatedResponse<Appointment>>
      getPendingAppointments({
    int page = 1,
    int limit = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    final body = await _apiClient.get(
      ApiConfig.pendingAppointmentsEndpoint,
      queryParameters: queryParams,
    ) as Map<String, dynamic>;

    return PaginatedResponse<Appointment>.fromJson(
      body['data'] as Map<String, dynamic>,
      Appointment.fromJson,
    );
  }

  /// Fetches available time slots for a given
  /// [clinicId] and [date].
  ///
  /// Optionally filter by [vetId] and specify
  /// [slotDuration] in minutes.
  Future<List<TimeSlot>> getAvailability({
    required String clinicId,
    required String date,
    String? vetId,
    int? slotDuration,
  }) async {
    final queryParams = <String, dynamic>{
      'clinicId': clinicId,
      'date': date,
      if (vetId != null) 'vetId': vetId,
      if (slotDuration != null)
        'slotDuration': slotDuration,
    };

    final body = await _apiClient.get(
      ApiConfig.availabilityEndpoint,
      queryParameters: queryParams,
    ) as Map<String, dynamic>;

    final slots = body['data'] as List<dynamic>;
    return slots
        .map(
          (e) => TimeSlot.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Fetches the audit history for an appointment.
  Future<List<AppointmentHistoryEntry>>
      getAppointmentHistory(
    String appointmentId,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.appointmentHistoryEndpoint(
        appointmentId,
      ),
    ) as Map<String, dynamic>;

    final entries = body['data'] as List<dynamic>;
    return entries
        .map(
          (e) => AppointmentHistoryEntry.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
