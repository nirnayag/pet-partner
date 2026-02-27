/// JWT access and refresh token pair returned by the
/// authentication API.
class AuthTokens {
  /// Creates an [AuthTokens].
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  /// Parses an [AuthTokens] from JSON.
  factory AuthTokens.fromJson(
    Map<String, dynamic> json,
  ) {
    return AuthTokens(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }

  /// The short-lived access token for API requests.
  final String accessToken;

  /// The long-lived token used to obtain a new
  /// [accessToken].
  final String refreshToken;

  /// Serialises this token pair back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
