import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../auth/auth_service.dart';
import '../auth/lock_preference.dart';

class AppLockSettings extends StatefulWidget {
  const AppLockSettings({super.key});
  @override
  State<AppLockSettings> createState() => _AppLockSettingsState();
}

class _AppLockSettingsState extends State<AppLockSettings> {
  final _la = AuthService();
  LockMethod _selected = LockMethod.deviceCredential;

  bool _anyAuth = false;
  bool _hasFace = false;
  bool _hasFinger = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final m = await LockPreference.load();
    final any = await _la.deviceSupportsAnyAuth();
    final biometrics = await _la.availableBiometrics();
    setState(() {
      _selected = m;
      _anyAuth = any;
      _hasFace   = biometrics.contains(BiometricType.face);
      _hasFinger = biometrics.contains(BiometricType.fingerprint) ||
          biometrics.contains(BiometricType.strong) ||
          biometrics.contains(BiometricType.weak);
    });
  }

  void _pick(LockMethod m) async {
    setState(() => _selected = m);
    await LockPreference.save(m);
    if (m == LockMethod.appPin) {
      if (!mounted) return;
      if (context.mounted) {
        Navigator.pushNamed(context, '/set-pin'); // implement below
      }
    } else if (m == LockMethod.otp) {
      if (!mounted) return;
      if (context.mounted) {
        Navigator.pushNamed(context, '/link-otp'); // implement below
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Lock')),
      body: ListView(
        children: [
          RadioListTile<LockMethod>(
            title: const Text('Off'),
            value: LockMethod.off,
            groupValue: _selected,
            onChanged: (v) => _pick(v!),
          ),
          RadioListTile<LockMethod>(
            title: const Text('Face ID'),
            subtitle: !_hasFace ? const Text('Not available/enrolled') : null,
            value: LockMethod.faceId,
            groupValue: _selected,
            onChanged: _hasFace ? (v) => _pick(v!) : null,
          ),
          RadioListTile<LockMethod>(
            title: const Text('Fingerprint'),
            subtitle: !_hasFinger ? const Text('Not available/enrolled') : null,
            value: LockMethod.fingerprint,
            groupValue: _selected,
            onChanged: _hasFinger ? (v) => _pick(v!) : null,
          ),
          RadioListTile<LockMethod>(
            title: const Text('Device PIN / Passcode'),
            subtitle: !_anyAuth ? const Text('Not supported on this device') : null,
            value: LockMethod.deviceCredential,
            groupValue: _selected,
            onChanged: _anyAuth ? (v) => _pick(v!) : null,
          ),
          const Divider(),
          RadioListTile<LockMethod>(
            title: const Text('App PIN (in-app)'),
            value: LockMethod.appPin,
            groupValue: _selected,
            onChanged: (v) => _pick(v!),
          ),
          RadioListTile<LockMethod>(
            title: const Text('One-Time PIN (OTP)'),
            subtitle: const Text('SMS/Email code each time'),
            value: LockMethod.otp,
            groupValue: _selected,
            onChanged: (v) => _pick(v!),
          ),
        ],
      ),
    );
  }
}
