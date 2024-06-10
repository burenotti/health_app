import 'package:flutter/material.dart';

Widget buildFormItem(
      {String? label,
      TextEditingController? controller,
      String? Function(String?)? validator,
      bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }