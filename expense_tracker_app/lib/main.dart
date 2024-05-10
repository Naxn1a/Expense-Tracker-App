import 'package:expense_tracker_app/screens/main_screen.dart';
import 'package:expense_tracker_app/screens/signin_screen.dart';
import 'package:expense_tracker_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future fetchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token ?? "";
  }

  @override
  Widget build(BuildContext context) {
    // final token = fetchToken().toString();
    // if (token.isNotEmpty) {
    //   return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     initialRoute: "/",
    //     routes: {
    //       "/": (context) => const HomeScreen(),
    //     },
    //   );
    // }
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
}
