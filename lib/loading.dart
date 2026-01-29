import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset( // BACKGROUND
              'assets/images/mu_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/mu_logo_slogan.png',
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20,),
                const CircularProgressIndicator(color: Colors.white,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}