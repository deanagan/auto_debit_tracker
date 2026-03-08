import 'package:flutter/material.dart';

import 'data/api_service.dart';
// import 'auth/auth_service.dart';                  // CHANGED: no longer needed
import 'auth/guard.dart';                           // CHANGED: use AppGuard() for unlock
import 'settings/app_lock_settings.dart';           // CHANGED: navigate to settings via MaterialPageRoute

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver { // CHANGED: observe lifecycle (optional)
  final ApiService _apiService = ApiService();
  final AppGuard _guard = AppGuard();                 // CHANGED: guard handles biometrics / PIN / OTP per user choice

  List<Map<String, dynamic>> _accounts = [];
  bool _loading = true;
  String? _error;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);        // CHANGED (optional)
    _authenticateAndFetch();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);     // CHANGED (optional)
    super.dispose();
  }

  // CHANGED (optional): decide if you want to re-lock on resume.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // If you want to re-auth when returning to the app, uncomment:
    // if (state == AppLifecycleState.resumed) {
    //   await _authenticateAndFetch(forceReload: false);
    // }
  }

  // CHANGED: use AppGuard().unlock(context) instead of your old AuthService.authenticate()
  Future<void> _authenticateAndFetch({bool forceReload = true}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final ok = await _guard.unlock(context);          // <- shows biometrics / device PIN / app PIN / OTP based on user choice
    if (!mounted) return;

    if (ok) {
      setState(() => _isAuthenticated = true);
      if (forceReload || _accounts.isEmpty) {
        await _fetchAccounts();
      } else {
        setState(() => _loading = false);
      }
    } else {
      setState(() {
        _isAuthenticated = false;
        _error = 'Authentication canceled or failed';
        _loading = false;
      });
    }
  }

  Future<void> _fetchAccounts() async {
    try {
      final accounts = await _apiService.fetchAccounts();
      if (!mounted) return;
      setState(() {
        _accounts = accounts;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(backgroundColor: Colors.grey[300]),
          Row(
            children: [
              // CHANGED: make settings button open App Lock Settings
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.black),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AppLockSettings()),
                  );
                },
              ),
              const SizedBox(width: 8),
              const Icon(Icons.search, color: Colors.black),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('Accounts', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      // CHANGED: add a retry button that re-triggers the guard
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 16)),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _authenticateAndFetch(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }
    if (!_isAuthenticated) {
      // CHANGED: make this actionable too
      return Center(
        child: FilledButton(
          onPressed: () => _authenticateAndFetch(),
          child: const Text('Authenticate'),
        ),
      );
    }
    if (_accounts.isEmpty) {
      return const Center(child: Text('No accounts found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _accounts.length,
      itemBuilder: (context, index) {
        final acc = _accounts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: const Icon(Icons.credit_card),
            title: Text(acc['name']),
            subtitle: const Text('Available\nBalance'),
            isThreeLine: true,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${acc['balance'].toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${acc['available'].toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalSection() {
    if (!_isAuthenticated || _error != null) {
      return const SizedBox.shrink();
    }
    return Container(
      color: Colors.blue[700],
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryRow('Total', '\$10,701.00', bold: true),
          const SizedBox(height: 8),
          _buildSummaryRow('Credits', '\$10,700.00'),
          _buildSummaryRow('Debits', '-\$20.00'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool bold = false}) {
    final style = bold ? const TextStyle(fontWeight: FontWeight.bold) : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(amount, style: style),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // CHANGED: Wrap with Scaffold to make the settings IconButton ripple look native (optional but recommended)
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildTitle(),
            Expanded(child: _buildBody()),
            _buildTotalSection(),
          ],
        ),
      ),
    );
  }
}
