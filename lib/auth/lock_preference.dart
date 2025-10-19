import 'package:shared_preferences/shared_preferences.dart';

enum LockMethod { off, faceId, fingerprint, deviceCredential, appPin, otp }

class LockPreference {
  static const _k = 'lock_method';

  static Future<void> save(LockMethod m) async =>
      (await SharedPreferences.getInstance()).setString(_k, m.name);

  /// Existing helper (kept if you still want a default-based load somewhere else)
  static Future<LockMethod> load() async {
    final sp = await SharedPreferences.getInstance();
    final v = sp.getString(_k);
    return LockMethod.values.firstWhere(
          (m) => m.name == v,
      orElse: () => LockMethod.deviceCredential,
    );
  }

  /// NEW: returns null if nothing saved yet (first run)
  static Future<LockMethod?> loadOrNull() async {
    final sp = await SharedPreferences.getInstance();
    final v = sp.getString(_k);
    if (v == null) return null;
    return LockMethod.values.firstWhere((m) => m.name == v, orElse: () => LockMethod.deviceCredential);
  }
}
