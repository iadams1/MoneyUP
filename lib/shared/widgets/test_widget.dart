import 'package:flutter/material.dart';
import 'package:moneyup/features/profile/widgets/terms_dialog.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: Center(
        child: TermsDialog(isProfile: false, isSignUp: true),
      ),
    );
  }
}