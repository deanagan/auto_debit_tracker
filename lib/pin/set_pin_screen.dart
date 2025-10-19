import 'package:flutter/material.dart';
import 'pin_service.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final _a = TextEditingController();
  final _b = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _busy = false;
  String? _err;

  @override
  void dispose() {
    _a.dispose();
    _b.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_a.text != _b.text) {
      setState(() => _err = 'PINs do not match');
      return;
    }
    setState(() { _busy = true; _err = null; });
    await PinService.setPin(_a.text);
    if (!mounted) return;
    Navigator.pop(context, true); // success
  }

  String? _pinValidator(String? v) {
    final s = v?.trim() ?? '';
    if (s.length < 4 || s.length > 8) return 'Enter 4–8 digits';
    if (!RegExp(r'^\d+$').hasMatch(s)) return 'Digits only';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set App PIN')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextFormField(
              controller: _a,
              decoration: const InputDecoration(labelText: 'New PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
              validator: _pinValidator,
              autofillHints: const [AutofillHints.oneTimeCode],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _b,
              decoration: const InputDecoration(labelText: 'Confirm PIN'),
              keyboardType: TextInputType.number,
              obscureText: true,
              validator: _pinValidator,
            ),
            if (_err != null) ...[
              const SizedBox(height: 8),
              Text(_err!, style: const TextStyle(color: Colors.red)),
            ],
            const Spacer(),
            FilledButton(
              onPressed: _busy ? null : _save,
              child: _busy ? const CircularProgressIndicator.adaptive() : const Text('Save PIN'),
            ),
          ]),
        ),
      ),
    );
  }
}
