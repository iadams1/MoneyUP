import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget 
{
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const ErrorDialog
  ({
    super.key,
    this.title = 'Error',
    required this.message,
    this.buttonText = 'OK',
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            const Icon(
              Icons.error_outline_rounded,
              size: 70,
              color: Colors.red,
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black54,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Expanded(
                child: ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}