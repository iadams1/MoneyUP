import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moneyup/features/auth/screens/confirmation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/shared/widgets/otp_input.dart';

class VerificationScreen extends StatefulWidget{
  final String email;

  const VerificationScreen({
    super.key, 
    required this.email
  });

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  // String _otpCode = "";
  // bool _isResendEnabled = true;

  final TextEditingController _codeController  = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  // This listens for when the user finishes the Plaid flow
  // PlaidLink.onSuccess.listen((Success success) {
  //   if (mounted) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const ConfirmationScreen()),
  //     );
  //   }

  // });

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    try {
      final response = await Supabase.instance.client.auth.verifyOTP(
        email: widget.email,
        token: _codeController.text.trim(),
        type: OtpType.signup,
      );

      if (response.session != null) {
        if (mounted) {
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ConfirmationScreen())
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid verification code"), backgroundColor: Colors.red),
      );
    }
  }


  Future<void> onResendCodePressed() async {
    // IMPLEMENT RESEND CODE LOGIC
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Code resent successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error resending code"), backgroundColor: Colors.red),
      );
    }
  }

  // void _openPlaidLink() {
  //   // Note: You will eventually need to fetch a real 'link_token' from your server here
  //   LinkTokenConfiguration config = LinkTokenConfiguration(
  //     token: "GENERATED_LINK_TOKEN", 
  //   );
  //   PlaidLink.open(configuration: config);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // BACKGROUND
        fit: StackFit.expand,
        children: [
          Image.asset(
              'assets/images/mu_bg.png',
              fit: BoxFit.fill
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(height: 20.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      'MONEYUP',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SF Pro'
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'VERIFICATION',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF Pro'
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 20.0, bottom: 40.0),
                    child: Text(
                      'Please enter the code we sent to the email address',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SF Pro'
                      ),
                    ),
                  ),
                  Container( // WHITE BOX CONTAINER
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: OtpInput(
                            length: 6,
                          ),
                        ),
                        Padding( // CONTINUE BUTTON
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <HexColor>[
                                    HexColor('#124074'), 
                                    HexColor('#332677'),
                                    HexColor('#124074'), 
                                    HexColor('#0D1250'),
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: _onContinuePressed, 
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent
                                ),
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(fontSize: 18.0, color: Colors.white)
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton( // RESEND CODE BUTTON
                          onPressed: onResendCodePressed,
                          child: Text(
                            'Resend Code',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            ),
                          )
                        ),
                      ],
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