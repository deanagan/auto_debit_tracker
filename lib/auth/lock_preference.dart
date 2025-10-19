import 'package:shared_preferences/shared_preferences.dart';

enum LockMethod { off, faceId, fingerprint, deviceCredential, appPin, otp }

class LockPreference {
  static const _k = 'lock_method';
  static Future<void> save(LockMethod m) async =>
      (await SharedPreferences.getInstance()).setString(_k, m.name);

  static Future<LockMethod> load() async {
    final sp = await SharedPreferences.getInstance();
    final v = sp.getString(_k);
    return LockMethod.values.firstWhere(
          (m) => m.name == v,
      orElse: () => LockMethod.deviceCredential,
    );
  }
}
