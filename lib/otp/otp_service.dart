class OtpService {
  // Wire these to your backend / Firebase later.
  Future<void> sendCode({required String to}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  Future<bool> verifyCode({required String to, required String code}) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return code.length >= 4; // placeholder logic – replace with real API result
  }
}
