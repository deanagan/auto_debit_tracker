import 'package:flutter/material.dart';
import 'pin_service.dart';

class EnterPinScreen extends StatefulWidget {
  const EnterPinScreen({super.key});

  @override
  State<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  final _pin = TextEditingController();
  String? _err;
  bool _busy = false;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    setState(() { _busy = true; _err = null; });
    final ok = await PinService.verify(_pin.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      Navigator.pop(context, true); // success
    } else {
      setState(() => _err = 'Incorrect PIN');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter App PIN')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TextField(
            controller: _pin,
            decoration: const InputDecoration(labelText: 'PIN'),
            keyboardType: TextInputType.number,
            obscureText: true,
            onSubmitted: (_) => _verify(),
          ),
          if (_err != null) ...[
            const SizedBox(height: 8),
            Text(_err!, style: const TextStyle(color: Colors.red)),
          ],
          const Spacer(),
          FilledButton(
            onPressed: _busy ? null : _verify,
            child: _busy ? const CircularProgressIndicator.adaptive() : const Text('Unlock'),
          )
        ]),
      ),
    );
  }
}
