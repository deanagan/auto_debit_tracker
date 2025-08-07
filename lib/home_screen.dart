import 'package:flutter/material.dart';

import 'data/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _accounts = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    try {
      final accounts = await _apiService.fetchAccounts();
      setState(() {
        _accounts = accounts;
        _loading = false;
      });
    } catch (e) {
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
              Icon(Icons.settings, color: Colors.black),
              SizedBox(width: 16),
              Icon(Icons.search, color: Colors.black),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Accounts',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAccountList() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text('Error: $_error'));
    if (_accounts.isEmpty) return const Center(child: Text('No accounts found'));

    var accounts = _accounts;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final acc = accounts[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Icon(Icons.credit_card),
            title: Text(acc['name']),
            subtitle: Text('Available\nBalance'),
            isThreeLine: true,
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${acc['balance'].toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('\$${acc['available'].toStringAsFixed(2)}', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalSection() {
    return Container(
      color: Colors.blue[700],
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryRow('Total', '\$10,701.00', bold: true),
          SizedBox(height: 8),
          _buildSummaryRow('Credits', '\$10,700.00'),
          _buildSummaryRow('Debits', '-\$20.00'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: bold ? TextStyle(fontWeight: FontWeight.bold) : null),
        Text(amount, style: bold ? TextStyle(fontWeight: FontWeight.bold) : null),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildTopBar(),
          _buildTitle(),
          Expanded(child: _buildAccountList()),
          _buildTotalSection(),
        ],
      ),
    );
  }

}


