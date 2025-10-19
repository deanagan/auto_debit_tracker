import 'package:local_auth/local_auth.dart';

class AuthService {
  final _auth = LocalAuthentication();

  Future<bool> deviceSupportsAnyAuth() => _auth.isDeviceSupported();
  Future<bool> canCheckBiometrics() => _auth.canCheckBiometrics;
  Future<List<BiometricType>> availableBiometrics() =>
      _auth.getAvailableBiometrics();

  /// Biometric-only (no PIN/passcode fallback).
  Future<bool> authBiometricOnly(String reason) {
    return _auth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(
        biometricOnly: true,
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );
  }

  /// Biometric OR device credential (Android PIN/Pattern/Password, iOS Passcode).
  Future<bool> authWithDeviceCredential(String reason) {
    return _auth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(
        biometricOnly: false, // allow system credential fallback
        useErrorDialogs: true,
        stickyAuth: true,
      ),
    );
  }

  Future<void> cancel() => _auth.stopAuthentication();
}
