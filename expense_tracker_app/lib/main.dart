import 'package:expense_tracker_app/screens/main_screen.dart';
import 'package:expense_tracker_app/screens/signin_screen.dart';
import 'package:expense_tracker_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context) => const MainScreen(),
        "/SignInScreen": (context) => const SignInScreen(),
        "/SignUpScreen": (context) => const SignUpScreen(),
      },
      // home: const MainScreen(),
    );
  }
}
