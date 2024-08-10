import 'package:flutter/material.dart';

class FormUtils {

  static inputDecoration(
      {String? hintText, Widget? prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      hintText: hintText ?? 'type here...',
      hintStyle: const TextStyle(color: Colors.black, fontSize: 12),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }
}
