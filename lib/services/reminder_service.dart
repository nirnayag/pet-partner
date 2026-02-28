import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/core/models/clinic/send_result.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/core/models/reminder/reminder.dart';
import 'package:partner/services/api_client.dart';

/// Handles reminder-related API calls.
class ReminderService {
  final _apiClient = locator<ApiClient>();

  /// Fetches a paginated list of reminders.
  ///
  /// Optionally filter by [status],
  /// [reminderType], [petId], or [ownerId].
  Future<PaginatedResponse<Reminder>> getReminders({
    int page = 1,
    int limit = 20,
    String? status,
    String? reminderType,
    String? petId,
    String? ownerId,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
      if (reminderType != null)
        'reminderType': reminderType,
      if (petId != null) 'petId': petId,
      if (ownerId != null) 'ownerId': ownerId,
    };

    final body = await _apiClient.get(
      ApiConfig.remindersEndpoint,
      queryParameters: queryParams,
    ) as Map<String, dynamic>;

    return PaginatedResponse<Reminder>.fromJson(
      body['data'] as Map<String, dynamic>,
      Reminder.fromJson,
    );
  }

  /// Fetches a single reminder by [id].
  Future<Reminder> getReminderById(
    String id,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.reminderByIdEndpoint(id),
    ) as Map<String, dynamic>;

    return Reminder.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Creates a new reminder.
  Future<Reminder> createReminder(
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.post(
      ApiConfig.remindersEndpoint,
      data: data,
    ) as Map<String, dynamic>;

    return Reminder.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Updates an existing reminder by [id].
  Future<Reminder> updateReminder(
    String id,
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.reminderByIdEndpoint(id),
      data: data,
    ) as Map<String, dynamic>;

    return Reminder.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Deletes a reminder by [id].
  Future<void> deleteReminder(String id) async {
    await _apiClient.delete(
      ApiConfig.reminderByIdEndpoint(id),
    );
  }

  /// Sends all pending reminders.
  Future<SendResult> sendPendingReminders() async {
    final body = await _apiClient.post(
      ApiConfig.remindersSendEndpoint,
    ) as Map<String, dynamic>;

    return SendResult.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }
}
