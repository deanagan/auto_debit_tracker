import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  static const _k = 'app_pin_hash';
  static const _store = FlutterSecureStorage();

  static const _androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  static const _iosOptions = IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  static Future<void> setPin(String pin) async {
    final hash = sha256.convert(utf8.encode(pin)).toString();
    print('DEBUG: Setting new PIN hash: $hash');
    await _store.write(
      key: _k,
      value: hash,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  static Future<bool> verify(String pin) async {
    final saved = await _store.read(
      key: _k,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
    if (saved == null) {
      print('DEBUG: No saved PIN found.');
      return false;
    }
    
    final hash = sha256.convert(utf8.encode(pin)).toString();
    print('DEBUG: Comparing saved hash ($saved) with input hash ($hash)');
    
    return _constTimeEq(saved, hash);
  }

  static Future<bool> exists() async => (await _store.read(
    key: _k,
    aOptions: _androidOptions,
    iOptions: _iosOptions,
  )) != null;

  static Future<void> clearPin() async {
    print('DEBUG: Clearing PIN from storage');
    await _store.delete(
      key: _k,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  static bool _constTimeEq(String a, String b) {
    if (a.length != b.length) return false;
    var r = 0;
    for (var i = 0; i < a.length; i++) {
      r |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return r == 0;
  }
}
