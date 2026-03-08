import 'dart:math';

class OtpService {
  // Static to persist across screen transitions for demo/debug purposes
  static String? _lastGeneratedCode;

  Future<void> sendCode({required String to}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    // For debugging: generate a 6-digit code and print it to the console
    _lastGeneratedCode = (Random().nextInt(900000) + 100000).toString();
    
    // In a real app, you would call an API (Twilio, SendGrid, Firebase) here
    print('DEBUG: Sending OTP $_lastGeneratedCode to $to');
  }

  Future<bool> verifyCode({required String to, required String code}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    
    // Check if the entered code matches our "secret" debug code or a master code
    return code == _lastGeneratedCode || code == "000000";
  }
}
