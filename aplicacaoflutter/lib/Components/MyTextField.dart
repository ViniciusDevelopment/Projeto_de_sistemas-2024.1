import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool isObscure;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.isObscure,
    required this.controller,
    });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)
          ),

          fillColor: Colors.white,
          filled: true,

          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.blueGrey)
        ),
      ),
    );
  }
}