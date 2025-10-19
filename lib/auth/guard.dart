import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'lock_preference.dart';
import '../settings/app_lock_settings.dart';
import '../pin/enter_pin_screen.dart';
import '../otp/enter_otp_screen.dart';

class AppGuard {
  final _la = AuthService();

  Future<bool> unlock(BuildContext context) async {
    // 1) Load saved choice (nullable)
    LockMethod? method = await LockPreference.loadOrNull();

    // 2) If none yet, force a choice by opening settings
    if (method == null) {
      if (!context.mounted) return false;
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AppLockSettings()),
      );
      // After user returns, read again
      method = await LockPreference.loadOrNull();
      if (method == null) {
        // User canceled out without saving any choice
        return false;
      }
    }

    // 3) Run the chosen method
    switch (method) {
      case LockMethod.off:
        return true;

      case LockMethod.faceId:
      case LockMethod.fingerprint:
        return _la.authBiometricOnly('Unlock with biometrics');

      case LockMethod.deviceCredential:
        return _la.authWithDeviceCredential('Unlock with device security');

      case LockMethod.appPin:
      // If no PIN set yet, your AppLockSettings already routes to SetPinScreen.
        if (!context.mounted) return false;
        final ok = await Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (_) => const EnterPinScreen()),
        );
        return ok ?? false;

      case LockMethod.otp:
        if (!context.mounted) return false;
        final ok = await Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (_) => const EnterOtpScreen()),
        );
        return ok ?? false;
    }
  }
}
