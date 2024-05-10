import 'dart:convert';

import 'package:expense_tracker_app/api/api.dart';
import 'package:expense_tracker_app/components/sign_button.dart';
import 'package:expense_tracker_app/components/sign_field.dart';
import 'package:expense_tracker_app/screens/signin_screen.dart';
import 'package:expense_tracker_app/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  handleSignUp() async {
    String username = usernameController.text;
    String password = passwordController.text;
    String passwordConfirm = passwordConfirmController.text;

    if (_formKey.currentState!.validate()) {
      if (password == passwordConfirm) {
        Map<String, dynamic> body = {
          "username": username,
          "password": password,
        };

        final res = jsonDecode((await methodPost(body, "users/signup")).body);
        if (res["status"] == 200) {
          if (mounted) {
            Navigator.popUntil(
              context,
              ModalRoute.withName('/'),
            );
            showDialog(
                context: context,
                builder: (context) => AlertDialog(title: Text(res["msg"])));
            return;
          }
        } else if (res["status"] == 400) {
          if (mounted) {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(title: Text(res["msg"])));
            return;
          }
          return;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
          ),
        );
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      SignField(
                          controller: usernameController,
                          obscureText: false,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                          label: const Text("Username"),
                          hintText: "Enter Username"),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SignField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        label: const Text('Password'),
                        hintText: 'Enter Password',
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SignField(
                        controller: passwordConfirmController,
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Password is required';
                          }
                          if (v != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        label: const Text('Confirm Password'),
                        hintText: 'Confirm Password',
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      SignButton(onTap: handleSignUp, text: "Sign Up"),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.popUntil(
                                context,
                                ModalRoute.withName('/'),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
