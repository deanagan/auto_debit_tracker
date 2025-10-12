import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

    if (!canAuthenticate) {
      return false;
    }

    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access your accounts',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      // Return false if any error occurs.
      return false;
    }
  }
}
