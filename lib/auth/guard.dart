import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'lock_preference.dart';

class AppGuard {
  final _la = AuthService();

  Future<bool> unlock(BuildContext context) async {
    final method = await LockPreference.load();

    switch (method) {
      case LockMethod.off:
        return true;

      case LockMethod.faceId:
      case LockMethod.fingerprint:
        return _la.authBiometricOnly('Unlock with biometrics');

      case LockMethod.deviceCredential:
        return _la.authWithDeviceCredential('Unlock with device security');

      case LockMethod.appPin:
        final ok = await Navigator.pushNamed<bool>(context, '/enter-pin');
        return ok ?? false;

      case LockMethod.otp:
        final ok = await Navigator.pushNamed<bool>(context, '/enter-otp');
        return ok ?? false;
    }
  }
}
