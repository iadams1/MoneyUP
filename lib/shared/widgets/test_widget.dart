import 'package:flutter/material.dart';
import 'package:moneyup/shared/widgets/bank_connection_banner.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: Center(
        child: BankConnectionSuccessBanner(), // 👈 your widget
      ),
    );
  }
}