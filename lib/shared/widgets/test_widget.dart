import 'package:flutter/material.dart';
import 'package:moneyup/features/auth/widgets/verification_resend_banner.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: const Center(
        child: VerificationResendBanner(),
      ),
    );
  }
}