import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  static const _k = 'app_pin_hash';
  static const _store = FlutterSecureStorage();

  static Future<void> setPin(String pin) async {
    final hash = sha256.convert(utf8.encode(pin)).toString();
    await _store.write(
      key: _k,
      value: hash,
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
  }

  static Future<bool> verify(String pin) async {
    final saved = await _store.read(key: _k);
    if (saved == null) return false;
    final hash = sha256.convert(utf8.encode(pin)).toString();
    return _constTimeEq(saved, hash);
  }

  static Future<bool> exists() async => (await _store.read(key: _k)) != null;

  static bool _constTimeEq(String a, String b) {
    if (a.length != b.length) return false;
    var r = 0;
    for (var i = 0; i < a.length; i++) {
      r |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return r == 0;
  }
}
