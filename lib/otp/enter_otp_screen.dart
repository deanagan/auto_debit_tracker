import 'package:flutter/material.dart';
import '../pin/pin_service.dart';
import 'otp_service.dart';

class EnterOtpScreen extends StatefulWidget {
  const EnterOtpScreen({super.key});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  final _code = TextEditingController();
  bool _busy = false;
  String? _err;
  String? _to;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) _to = args;
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _code.text.trim();
    if (code.isEmpty) { setState(() => _err = 'Enter the code'); return; }
    setState(() { _busy = true; _err = null; });
    final ok = await OtpService().verifyCode(to: _to ?? '', code: code);
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      await PinService.clearPin();
      if (!mounted) return;
      // Swap OTP screen for Set PIN screen
      Navigator.pushReplacementNamed(context, '/set-pin');
    } else {
      setState(() => _err = 'Invalid code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Identity')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Sent to: ${_to ?? 'Unknown'}', style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          TextField(
            controller: _code,
            decoration: const InputDecoration(labelText: '6-digit Code', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            onSubmitted: (_) => _verify(),
          ),
          if (_err != null) ...[
            const SizedBox(height: 8),
            Text(_err!, style: const TextStyle(color: Colors.red)),
          ],
          const Spacer(),
          FilledButton(
            onPressed: _busy ? null : _verify,
            child: _busy ? const CircularProgressIndicator.adaptive() : const Text('Verify & Reset PIN'),
          ),
        ]),
      ),
    );
  }
}
