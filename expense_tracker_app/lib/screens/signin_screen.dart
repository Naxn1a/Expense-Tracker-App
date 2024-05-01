import 'package:expense_tracker_app/components/sign_button.dart';
import 'package:expense_tracker_app/components/sign_field.dart';
import 'package:expense_tracker_app/screens/signup_screen.dart';
import 'package:expense_tracker_app/widgets/background_widget.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  handleSignIn() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign In Successful'),
        ),
      );
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
                        'Expense Tracker',
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
                        controller: TextEditingController(),
                        obscureText: false,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter username';
                          }
                          return null;
                        },
                        label: const Text('Username'),
                        hintText: 'Enter Username',
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SignField(
                        controller: TextEditingController(),
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        label: const Text('Password'),
                        hintText: 'Enter Password',
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      SignButton(onTap: handleSignIn, text: "Sign In"),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
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
                                  builder: (e) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
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
