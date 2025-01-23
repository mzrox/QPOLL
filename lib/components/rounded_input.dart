import 'package:flutter/material.dart';
import '../Constants/constants.dart';
import 'InputContainer.dart';

class RoundedInput extends StatelessWidget {
  const RoundedInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.controller, // Add controller
    this.child, // Add child property
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextEditingController controller; // Controller for managing input
  final Widget? child; // Optional child property

  @override
  Widget build(BuildContext context) {
    return InputContainer(
      child: child ??
          TextField(
            controller: controller, // Link the controller
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              icon: Icon(icon, color: kPrimaryColor),
              hintText: hint,
              border: InputBorder.none,
            ),
          ),
    );
  }
}
