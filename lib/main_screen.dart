import 'package:flutter/material.dart';
import 'package:auto_debit_tracker/pay_screen.dart';
import 'package:auto_debit_tracker/trends_screen.dart';
import 'package:auto_debit_tracker/home_screen.dart';

import 'icons/svg_nav_icon.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    HomeScreen(), // temp
    PayScreen(), // temp
    HomeScreen(), // temp
    TrendsScreen(), // temp
    //AccountsScreen(),
    //PayScreen(),
    //PledgeScreen(),
    //FeaturesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // No shifting please
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: 'Accounts'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: 'Pay'),
          BottomNavigationBarItem(icon:
          SvgNavIcon(assetName: 'assets/icons/pay.svg'),
          //PledgeMoneyIcon(size: 28, color: Colors.grey),
              label: 'Pledge'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Trends'),

        ],
      ),
    );
  }
}


