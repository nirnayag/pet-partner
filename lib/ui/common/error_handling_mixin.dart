import 'package:partner/services/api_client.dart';
import 'package:stacked/stacked.dart';

/// Mixin that provides standardised error handling
/// for ViewModels.
///
/// Wraps API calls in [runSafe] to map exceptions
/// to user-friendly messages and manage error state.
mixin ErrorHandlingMixin on BaseViewModel {
  String? _errorMessage;

  /// The current error message, or `null`.
  String? get errorMessage => _errorMessage;

  bool _hasError = false;

  /// Whether an error is currently set.
  @override
  bool get hasError => _hasError;

  /// Executes [action] and catches common exceptions,
  /// mapping them to user-friendly messages.
  ///
  /// Returns the result of [action] on success, or
  /// `null` on failure. Calls [onError] when an error
  /// occurs.
  Future<T?> runSafe<T>(
    Future<T> Function() action, {
    String? fallbackMessage,
    void Function()? onError,
  }) async {
    try {
      clearError();
      return await action();
    } on ApiException catch (e) {
      final message = _messageForStatus(e) ??
          e.message;
      setError(message);
    } on Exception catch (_) {
      setError(
        fallbackMessage ??
            'Something went wrong. '
                'Please try again.',
      );
    }
    onError?.call();
    return null;
  }

  /// Sets an error message and notifies listeners.
  @override
  void setError(dynamic error) {
    _errorMessage = error?.toString();
    _hasError = true;
    notifyListeners();
  }

  /// Clears any current error state.
  void clearError() {
    _errorMessage = null;
    _hasError = false;
  }

  String? _messageForStatus(ApiException e) {
    switch (e.statusCode) {
      case 401:
        // Handled by auth interceptor.
        return null;
      case 403:
        return 'You do not have permission '
            'to perform this action.';
      case 404:
        return 'The requested resource '
            'was not found.';
      default:
        return null;
    }
  }
}
