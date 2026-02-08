import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/services/functions.dart';
import '../../data/models/http_result.dart';

enum AuthDestination {
  invoice,
  bookingConfirmation,
  bookingConfirmationRental,
  selectTask,
  getStarted,
}

class AuthVerificationResult {
  const AuthVerificationResult({this.destination, this.error});

  final AuthDestination? destination;
  final String? error;

  bool get hasError => error != null && error!.isNotEmpty;
}

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;
  int resendSeconds = 60;
  Timer? _resendTimer;
  String errorMessage = '';

  bool get hasInternet => internet;

  bool get hasCountries => countries.isNotEmpty;

  int get dialMinLength =>
      hasCountries ? countries[phcode]['dial_min_length'] : 0;

  Future<void> loadCountries() async {
    isLoading = true;
    notifyListeners();
    await getCountryCode();
    isLoading = false;
    notifyListeners();
  }

  bool canSubmitPhone(String phone) {
    return phone.length >= dialMinLength;
  }

  Future<HttpResult> requestOtp(String phone) async {
    isLoading = true;
    notifyListeners();
    phnumber = phone;
    final result = await otpCall(phone);
    isLoading = false;
    notifyListeners();
    return result;
  }

  void startResendTimer({int startFrom = 60}) {
    _resendTimer?.cancel();
    resendSeconds = startFrom;
    notifyListeners();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds > 0) {
        resendSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  Future<AuthVerificationResult> verifyOtp(String code) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final verification = await verifyNumber(phnumber, code);
    if (!verification.isSuccess) {
      final formattedError = _formatApiError(verification.result);
      if (formattedError == 'These credentials do not match our records.') {
        final exists = await validateMobileForLogin(phnumber);
        if (exists == false) {
          isLoading = false;
          notifyListeners();
          return const AuthVerificationResult(
            destination: AuthDestination.getStarted,
          );
        }
      }
      errorMessage = formattedError;
      isLoading = false;
      notifyListeners();
      return AuthVerificationResult(error: errorMessage);
    }

    final userCheck = await verifyUser(phnumber);
    isLoading = false;
    notifyListeners();
    if (userCheck == true) {
      return AuthVerificationResult(destination: _resolveDestination());
    }
    if (userCheck == false) {
      return const AuthVerificationResult(
          destination: AuthDestination.getStarted);
    }
    return AuthVerificationResult(error: userCheck?.toString());
  }

  String _formatApiError(dynamic result) {
    if (result is Map) {
      final errors = result['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) {
          return first.first.toString();
        }
        if (first != null) {
          return first.toString();
        }
      }
      final message = result['message'];
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }
    if (result != null && result.toString().trim().isNotEmpty) {
      return result.toString();
    }
    return 'Server error';
  }

  AuthDestination _resolveDestination() {
    if (userRequestData.isNotEmpty && userRequestData['is_completed'] == 1) {
      return AuthDestination.invoice;
    }
    if (userRequestData.isNotEmpty && userRequestData['is_completed'] != 1) {
      return userRequestData['is_rental'] == true
          ? AuthDestination.bookingConfirmationRental
          : AuthDestination.bookingConfirmation;
    }
    return AuthDestination.selectTask;
  }

  Future<void> retryFetchCountries() async {
    internetTrue();
    await loadCountries();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }
}
