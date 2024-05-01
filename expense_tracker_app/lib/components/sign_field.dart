import 'package:flutter/material.dart';

class SignField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget label;
  final String hintText;

  const SignField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.validator,
    required this.label,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        label: label,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black26,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
