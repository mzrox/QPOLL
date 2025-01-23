import 'package:flutter/material.dart';
import '../Constants/constants.dart';
import 'InputContainer.dart';

class RoundedPasswordInput extends StatelessWidget {
  const RoundedPasswordInput({
    Key? key,
    required this.hint,
    required this.controller, // Add controller
  }) : super(key: key);

  final String hint;
  final TextEditingController controller; // Controller for managing input

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: TextField(
        controller: controller, // Connect controller
        cursorColor: kPrimaryColor,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: kPrimaryColor),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
