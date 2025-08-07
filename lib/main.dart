import 'package:flutter/material.dart';
import 'main_screen.dart';

void main() {
  runApp(AutoDebitTrackerApp());
}

class AutoDebitTrackerApp extends StatelessWidget {
  const AutoDebitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Debit Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.blueAccent[100],
      ),
      home: MainScreen(),
    );
  }
}
