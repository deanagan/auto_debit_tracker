# Building Secure Flutter Apps: A Lightning Talk

---

## 🔒 The Challenge
"How do we secure sensitive data while providing a seamless user experience?"

*   Biometrics (Face ID / Fingerprint)
*   App-level PIN (Fallback)
*   Identity Recovery (OTP)

---

## 🛠️ The Tech Stack

*   **`local_auth`**: Native biometric integration.
*   **`flutter_secure_storage`**: Encrypted key-value storage.
*   **`crypto`**: SHA-256 hashing for PIN security.

---

## 🤳 Step 1: Face ID & Biometrics

We use the `local_auth` package to communicate with the device's hardware.

```dart
// lib/auth/auth_service.dart
final _auth = LocalAuthentication();

Future<bool> authBiometricOnly(String reason) {
  return _auth.authenticate(
    localizedReason: reason,
    options: const AuthenticationOptions(
      biometricOnly: true, // Forces Face ID / Fingerprint
      stickyAuth: true,    // Keeps session alive on app switch
    ),
  );
}
```

---

## 🔑 Step 2: Custom App PIN

If biometrics aren't preferred, we use a custom App PIN.

*   **Security Rule**: Never store the raw PIN!
*   **Implementation**: Store a SHA-256 hash in Secure Storage.

```dart
static Future<void> setPin(String pin) async {
  final hash = sha256.convert(utf8.encode(pin)).toString();
  await _store.write(key: 'app_pin_hash', value: hash);
}
```

---

## ☁️ Local vs. Cloud Security

Banking apps aren't just local; they are **Hybrid**.

*   **Local**: Face ID / PIN happens in the device's **Secure Enclave**. Data never leaves the phone.
*   **Cloud**: Authentication generates a session token sent to the backend to authorize transactions.

---

## 🛡️ What is FIDO2?

The open standard for passwordless authentication.

*   **F**ast **I**dentity **D**online **O**nline.
*   **WebAuthn**: The API that allows apps to communicate with servers for auth.
*   **CTAP**: The protocol for devices (phones, YubiKeys) to talk to the authenticator.
*   **No Shared Secrets**: The server never sees your "password" or private key.

---

## 🚀 The Future: Passkeys (FIDO2)

Passkeys replace passwords with **Public Key Cryptography**.

*   **Device**: Holds a private key (Face ID unlocks it).
*   **Server**: Holds a public key.
*   **Result**: Phishing-proof authentication.
*   *In Flutter*: Use the `passkeys` package + a backend.

---

## 🚑 Step 3: Identity Recovery (The "Forgot PIN" Flow)

What if the user forgets their PIN? 

1.  **Identity Verification**: Send a 6-digit OTP via Email/SMS.
2.  **Clear & Reset**: Upon successful OTP verification, clear the old PIN hash and prompt for a new one.

---

## ⚠️ Pitfalls Encountered (The "Hard Lessons")

### 1. The `mounted` Trap
Async navigation can outlive its widget.
*   *Solution*: Always check `if (!mounted) return;` after `await`.

### 2. Navigation State Battles
`IndexedStack` (Bottom Nav) initializes children immediately.
*   *Solution*: Use a "Concurrency Lock" (`static bool _isUnlocking`) to prevent multiple auth triggers.

---

## 🏁 Summary

*   **Layer 1**: Biometrics (Fastest)
*   **Layer 2**: Secure PIN (Reliable Fallback)
*   **Layer 3**: OTP Recovery (Safety Net)

### "Security is a process, not a product."
**Thank You!**
