import 'package:flutter/material.dart';
import 'package:moneyup/start/info.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(// BACKGROUND
            'assets/images/mu_bg.png',
            fit: BoxFit.fill
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 150.0, left: 55.0, right: 55.0),
              child: Column(
                children: <Widget> [
                  Image.asset(
                    'assets/images/mu_check.png',
                    width: 240,
                    height: 240,
                    fit: BoxFit.cover
                  ),
                  const SizedBox(height: 40.0),
                  Text(
                    'VERIFIED!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    'Cha Ching! You have successfully verified your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 90.0),
                  Padding( // GET STARTED BUTTON
                    padding: const EdgeInsets.only(top:20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      ),
                      child:ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InfoScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.transparent,
                        ),
                        child: Text(
                        'Get Started',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}