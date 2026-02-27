/// Generic API response wrapper matching the backend
/// `{ success, message, data, error }` format.
class ApiResponse<T> {
  /// Creates an [ApiResponse].
  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
  });

  /// Parses an [ApiResponse] from JSON.
  ///
  /// The [fromJsonT] callback deserialises the `data`
  /// field into a concrete [T] value.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      error: json['error'] != null
          ? ApiError.fromJson(
              json['error'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Whether the API call succeeded.
  final bool success;

  /// Optional human-readable message from the server.
  final String? message;

  /// The deserialised response payload.
  final T? data;

  /// Error details when [success] is `false`.
  final ApiError? error;

  /// Serialises this response back to JSON.
  ///
  /// The [toJsonT] callback serialises [data] into a
  /// JSON-compatible value.
  Map<String, dynamic> toJson(
    Object? Function(T value)? toJsonT,
  ) {
    return <String, dynamic>{
      'success': success,
      if (message != null) 'message': message,
      if (data != null && toJsonT != null)
        'data': toJsonT(data as T),
      if (error != null) 'error': error!.toJson(),
    };
  }
}

/// Structured error returned by the API.
class ApiError {
  /// Creates an [ApiError].
  const ApiError({
    required this.code,
    required this.message,
    this.details,
  });

  /// Parses an [ApiError] from JSON.
  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as String,
      message: json['message'] as String,
      details: (json['details'] as List<dynamic>?)
          ?.map(
            (e) => ApiErrorDetail.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  /// Machine-readable error code.
  final String code;

  /// Human-readable error message.
  final String message;

  /// Optional field-level validation errors.
  final List<ApiErrorDetail>? details;

  /// Serialises this error back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'message': message,
      if (details != null)
        'details': details!.map((d) => d.toJson()).toList(),
    };
  }
}

/// A single field-level validation error.
class ApiErrorDetail {
  /// Creates an [ApiErrorDetail].
  const ApiErrorDetail({
    required this.path,
    required this.message,
    required this.code,
  });

  /// Parses an [ApiErrorDetail] from JSON.
  factory ApiErrorDetail.fromJson(
    Map<String, dynamic> json,
  ) {
    return ApiErrorDetail(
      path: (json['path'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      message: json['message'] as String,
      code: json['code'] as String,
    );
  }

  /// The JSON path to the invalid field.
  final List<String> path;

  /// Human-readable validation message.
  final String message;

  /// Machine-readable validation code.
  final String code;

  /// Serialises this detail back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'path': path,
      'message': message,
      'code': code,
    };
  }
}
