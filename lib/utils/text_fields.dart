import 'package:flutter/material.dart';

Widget customTextField({
  required TextEditingController controller,
  required String labelText,
  String? errorText,
  bool obscureText = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Center(
      child: Container(
        width: 300,
        child: TextField(
          style: const TextStyle(fontSize: 14.0),
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            errorText: errorText,
          ),
        ),
      ),
    ),
  );
}
