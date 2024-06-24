import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  InputDecoration? decoration;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.decoration,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      decoration: decoration ??
          InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
    );
  }
}
