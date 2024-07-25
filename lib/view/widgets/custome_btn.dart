import 'package:chatapp/view/widgets/constant.dart';
import 'package:flutter/material.dart';

class CustomeButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const CustomeButton(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.kcPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        title!,
        style: const TextStyle(
          color: Colors.white, // Text color
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
