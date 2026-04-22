import 'package:flutter/material.dart';
import 'package:moneyup/shared/widgets/error_system.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String message = "Hello there.";

    Future.microtask(() {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => ErrorDialog(
          title: 'Login/Signup Failed',
          message: message,
          buttonText: 'Try Again',
          onButtonPressed: () => Navigator.pop(context),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: const Center(
        child: Text('Preview Screen'),
      ),
    );
  }
}