import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '/features/auth/screens/signup.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Future<void> _completeWelcome(BuildContext context) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('hasSeenOnboarding', true);
  //   if (context.mounted) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => const SignUpScreen()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/mu_bg.png',
            fit: BoxFit.fill
          ),
          SizedBox(height: 50),
          Image.asset(
            'assets/images/mu_start.png', 
            height: 500,
            width: double.infinity,
            fit: BoxFit.none,
            alignment: Alignment.topCenter,
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 550,),
                Text(
                  'YOUR MONEY. YOUR MOVE.',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.w400,
                    fontFamily: "SF Pro",
                    color: Colors.white
                    ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  'Master your money-without the stress.',
                  style: TextStyle(
                    fontSize: 41.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "SF Pro",
                    color: Colors.white
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Positioned( // NEXT BUTTON
            bottom: 10,
            right: 0,
            child: IconButton(
              icon: Image.asset('assets/icons/doubleArrowRight.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen())
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}