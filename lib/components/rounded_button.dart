import 'package:flutter/material.dart';
import '../Constants/constants.dart';

class RoundedButton extends StatefulWidget {
  const RoundedButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final Future<void> Function() onPressed;

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading) return; // Prevent multiple taps during loading
    setState(() {
      _isLoading = true; // Show loading indicator
    });
    try {
      await widget.onPressed(); // Execute the provided async function
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: _handlePress,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: _isLoading ? Colors.grey : kPrimaryColor, // Show grey if loading
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: _isLoading
            ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        )
            : Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
