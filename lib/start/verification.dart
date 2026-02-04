import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moneyup/start/confirmation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moneyup/services/plaid_connect.dart'; 
//import 'package:plaid_flutter/plaid_flutter.dart'; 

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

  // final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController  = TextEditingController();
  final int _codeLength = 6;

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


  Future<void> _onResendCodePressed() async {
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
                        TextFormField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: _codeLength,
                          style: TextStyle(
                            fontSize: 24,
                            letterSpacing: 10,
                          ),
                          decoration: InputDecoration(
                            hintText: '_ _ _ _ _ _',
                            border: InputBorder.none,
                            counterText: "",
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: EdgeInsets.symmetric(vertical: 100),
                          ),
                          onChanged: (value) {
                            if (value.length == _codeLength) {
                              //
                            }
                          },
                        ),
                        Padding( // CONTINUE BUTTON
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: AlignmentGeometry.centerRight,
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
                                child: const Text(
                                  'Continue',
                                  style: TextStyle(fontSize: 18.0,)
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton( // RESEND CODE BUTTON
                          onPressed: _onResendCodePressed,
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