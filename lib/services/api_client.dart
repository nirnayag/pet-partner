import 'dart:async';

import 'package:dio/dio.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/services/secure_storage_service.dart';
import 'package:stacked_services/stacked_services.dart';

/// Thrown when an API call fails.
///
/// Wraps HTTP status codes and error messages from the
/// server into a single, readable exception.
class ApiException implements Exception {
  /// Creates an [ApiException].
  const ApiException({
    required this.message,
    this.statusCode,
  });

  /// HTTP status code, if available.
  final int? statusCode;

  /// Human-readable error description.
  final String message;

  @override
  String toString() => message;
}

/// HTTP client wrapper built on [Dio].
///
/// Handles token injection, automatic 401 refresh with
/// a [Completer] lock, and user-friendly error mapping.
class ApiClient {
  /// Creates an [ApiClient].
  ///
  /// Accepts an optional [Dio] instance for testing.
  /// Production code should rely on the defaults.
  ApiClient({Dio? dio}) {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: ApiConfig.connectionTimeout,
            receiveTimeout: ApiConfig.receiveTimeout,
            contentType: Headers.jsonContentType,
          ),
        );
    _setupInterceptors();
  }

  late final Dio _dio;

  /// Prevents concurrent token refresh attempts.
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  // ---- Interceptors ------------------------------------

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final storage =
        locator<SecureStorageService>();
    final token = await storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] =
          'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401) {
      return _handle401(error, handler);
    }
    handler.next(error);
  }

  // ---- 401 handling ------------------------------------

  Future<void> _handle401(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final storage =
        locator<SecureStorageService>();
    final storedRefreshToken =
        await storage.getRefreshToken();

    if (storedRefreshToken == null ||
        storedRefreshToken.isEmpty) {
      await _navigateToLogin();
      return handler.next(error);
    }

    // Another request already triggered a refresh —
    // wait for it to finish, then retry.
    if (_isRefreshing) {
      try {
        await _refreshCompleter?.future;
        return _retry(error.requestOptions, handler);
      } on Object catch (_) {
        return handler.next(error);
      }
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      // Call refresh endpoint directly (avoids
      // circular dependency with AuthService).
      final response = await _dio.post<dynamic>(
        ApiConfig.refreshTokenEndpoint,
        data: <String, dynamic>{
          'refreshToken': storedRefreshToken,
        },
      );

      final body =
          response.data as Map<String, dynamic>;
      final data =
          body['data'] as Map<String, dynamic>?;

      if (data == null) {
        throw const ApiException(
          message:
              'Token refresh failed: no data received',
        );
      }

      final newAccess =
          data['accessToken'] as String;
      final newRefresh =
          data['refreshToken'] as String;

      await storage.saveAccessToken(newAccess);
      await storage.saveRefreshToken(newRefresh);

      _refreshCompleter!.complete();
      return _retry(error.requestOptions, handler);
    } catch (refreshError) {
      _refreshCompleter!.completeError(refreshError);
      await storage.clearTokens();
      await _navigateToLogin();
      return handler.next(error);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _retry(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final storage =
          locator<SecureStorageService>();
      final token = await storage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        requestOptions.headers['Authorization'] =
            'Bearer $token';
      }
      final response =
          await _dio.fetch<dynamic>(requestOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<void> _navigateToLogin() async {
    try {
      await locator<NavigationService>()
          .clearStackAndShow<void>(
        Routes.loginView,
      );
    } on Object catch (_) {
      // NavigationService unavailable (e.g. in tests)
    }
  }

  // ---- Error mapping -----------------------------------

  ApiException _mapError(DioException e) {
    final statusCode = e.response?.statusCode;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          statusCode: statusCode,
          message: 'Connection timed out. '
              'Please check your network.',
        );

      case DioExceptionType.badResponse:
        return _mapBadResponse(e);

      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Request was cancelled.',
        );

      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return ApiException(
          statusCode: statusCode,
          message: e.message ??
              'Network error. '
                  'Please check your connection.',
        );
    }
  }

  ApiException _mapBadResponse(DioException e) {
    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String? serverMessage;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      final message = data['message'];
      serverMessage = error is String
          ? error
          : message is String
              ? message
              : null;
    }

    if (serverMessage != null) {
      return ApiException(
        statusCode: statusCode,
        message: serverMessage,
      );
    }

    return ApiException(
      statusCode: statusCode,
      message: _defaultMessageForStatus(statusCode),
    );
  }

  String _defaultMessageForStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request.';
      case 401:
        return 'Session expired. Please log in again.';
      case 403:
        return 'You do not have permission.';
      case 404:
        return 'Resource not found.';
      case 422:
        return 'Validation error.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Server error ($statusCode).';
    }
  }

  // ---- Public HTTP methods -----------------------------

  /// Sends a GET request to [path].
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Sends a POST request to [path].
  Future<dynamic> post(
    String path, {
    dynamic data,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Sends a PUT request to [path].
  Future<dynamic> put(
    String path, {
    dynamic data,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Sends a PATCH request to [path].
  Future<dynamic> patch(
    String path, {
    dynamic data,
  }) async {
    try {
      final response = await _dio.patch<dynamic>(
        path,
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Sends a DELETE request to [path].
  Future<dynamic> delete(String path) async {
    try {
      final response =
          await _dio.delete<dynamic>(path);
      return response.data;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }
}
