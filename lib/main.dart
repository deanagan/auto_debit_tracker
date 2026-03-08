import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'pin/enter_pin_screen.dart';
import 'pin/set_pin_screen.dart';
import 'otp/link_otp_screen.dart';
import 'otp/enter_otp_screen.dart';

void main() {
  runApp(const AutoDebitTrackerApp());
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
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/enter-pin': (context) => const EnterPinScreen(),
        '/set-pin': (context) => const SetPinScreen(),
        '/link-otp': (context) => const LinkOtpScreen(),
        '/enter-otp': (context) => const EnterOtpScreen(),
      },
    );
  }
}
