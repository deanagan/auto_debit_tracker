# Security Flow

```mermaid
flowchart TD
  A[Home] --> B[AppGuard]
  B --> C[Read LockMethod]
  C --> D{Which method}

  D -->|Biometric| E[Biometric Auth]
  E -->|success| S[Success]
  E -->|fail| F[Failure]

  D -->|Device Credential| G[Device Credential]
  G -->|success| S
  G -->|fail| F

  D -->|App PIN| H{PIN set}
  H -->|No| I[Set PIN]
  I --> J[Enter PIN]
  H -->|Yes| J
  J -->|correct| S
  J -->|wrong| F

  D -->|OTP| K{Linked}
  K -->|No| L[Link OTP]
  L --> M[Enter OTP]
  K -->|Yes| M
  M -->|valid| S
  M -->|invalid| F

  S --> T[Authenticated UI]

  subgraph Z[Settings]
    Z1[AppLockSettings]
    Z2[Save LockMethod]
  end
  Z1 --> Z2 --> C

  subgraph LEGEND[Legend]
    L1[Home = HomeScreen]
    L2[AppGuard = auth/guard]
    L3[Biometric Auth = auth/local_auth_service]
    L4[PIN nodes = pin screens and services]
    L5[OTP nodes = otp screens and services]
    L6[Success = data/api_service]
  end
```

Detailed mapping:

- Home: lib/home_screen.dart (initState -> _authenticateAndFetch)
- AppGuard: lib/auth/guard.dart
- Read LockMethod: lib/auth/lock_preference.dart (set in AppLockSettings)
- Biometric Auth: lib/auth/local_auth_service.dart (authBiometricOnly)
- Device Credential: lib/auth/local_auth_service.dart (authWithDeviceCredential)
- Set PIN: lib/pin/set_pin_screen.dart
- Enter PIN / PinService.verify: lib/pin/enter_pin_screen.dart, lib/pin/pin_service.dart
- Link OTP: lib/otp/link_otp_screen.dart
- Enter OTP / OtpService.verifyCode: lib/otp/enter_otp_screen.dart, lib/otp/otp_service.dart
- Authenticated UI / Success: lib/data/api_service.dart
- AppLockSettings: lib/settings/app_lock_settings.dart
- Save LockMethod: lib/auth/lock_preference.dart
