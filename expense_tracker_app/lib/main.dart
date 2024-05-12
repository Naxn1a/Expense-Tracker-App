import 'package:expense_tracker_app/screens/dashboard_screen.dart';
import 'package:expense_tracker_app/screens/main_screen.dart';
import 'package:expense_tracker_app/screens/signin_screen.dart';
import 'package:expense_tracker_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var hasToken = false;

  Future<dynamic> fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      hasToken = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (hasToken) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: "/dashboard",
              routes: {
                "/dashboard": (context) => const DashboardScreen(),
              },
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: "/",
              routes: {
                "/": (context) => const MainScreen(),
                "/SignInScreen": (context) => const SignInScreen(),
                "/SignUpScreen": (context) => const SignUpScreen(),
              },
            );
          }
        });
  }
}
