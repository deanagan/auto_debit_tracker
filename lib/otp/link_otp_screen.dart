import 'package:flutter/material.dart';
import 'otp_service.dart';

class LinkOtpScreen extends StatefulWidget {
  const LinkOtpScreen({super.key});

  @override
  State<LinkOtpScreen> createState() => _LinkOtpScreenState();
}

class _LinkOtpScreenState extends State<LinkOtpScreen> {
  final _to = TextEditingController();
  bool _busy = false;
  String? _err;

  @override
  void dispose() {
    _to.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final to = _to.text.trim();
    if (to.isEmpty) { setState(() => _err = 'Enter phone or email'); return; }
    setState(() { _busy = true; _err = null; });
    try {
      await OtpService().sendCode(to: to);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/enter-otp', arguments: to);
    } catch (e) {
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Link One-Time PIN')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextField(
            controller: _to,
            decoration: const InputDecoration(
              labelText: 'Phone or Email',
              hintText: '+61 4xx xxx xxx or you@example.com',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          if (_err != null) ...[
            const SizedBox(height: 8),
            Text(_err!, style: const TextStyle(color: Colors.red)),
          ],
          const Spacer(),
          FilledButton(
            onPressed: _busy ? null : _send,
            child: _busy ? const CircularProgressIndicator.adaptive() : const Text('Send Code'),
          ),
        ]),
      ),
    );
  }
}
