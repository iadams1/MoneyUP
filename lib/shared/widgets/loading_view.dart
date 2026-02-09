import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                height: 400,
                width: 400,
                fit: BoxFit.cover,
              ),

              const SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),             
            ],
          ),
        ),
      ],
    );
  }
}