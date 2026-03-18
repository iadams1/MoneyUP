import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/features/auth/screens/confirmation.dart';
import '/services/auth_service.dart';
import '/shared/widgets/otp_input.dart';

class VerificationScreen extends StatefulWidget {
  final String email;

  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _codeController = TextEditingController();
  final int _codeLength = 6;

  // Instance of AuthService
  final AuthService _authService = AuthService();

  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onContinuePressed() async {
    final code = _codeController.text.trim();
    if (code.length != _codeLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the full 6-digit code"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final response = await _authService.verifyOtp(
        email: widget.email,
        token: code,
        type: OtpType.signup,
      );

      if (response.session != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ConfirmationScreen()),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  Future<void> _onResendCodePressed() async {
    setState(() => _isResending = true);

    try {
      await _authService.resendOtp(email: widget.email, type: OtpType.signup);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Code resent successfully! Check your email."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error resending code"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/mu_bg.png', fit: BoxFit.fill),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 20.0),
                    child: const Text(
                      'MONEYUP',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SF Pro',
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 20.0),
                    child: const Text(
                      'VERIFICATION',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SF Pro',
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                    child: const Text(
                      'Please enter the code we sent to the email address',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SF Pro',
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Column(
                      children: [
                        OtpInput(),
                        // TextFormField(
                        //   controller: _codeController,
                        //   keyboardType: TextInputType.number,
                        //   textAlign: TextAlign.center,
                        //   maxLength: _codeLength,
                        //   style: const TextStyle(
                        //     fontSize: 24,
                        //     letterSpacing: 10,
                        //   ),
                        //   decoration: InputDecoration(
                        //     hintText: '_ _ _ _ _ _',
                        //     border: InputBorder.none,
                        //     counterText: "",
                        //     filled: true,
                        //     fillColor: Colors.transparent,
                        //     contentPadding: const EdgeInsets.symmetric(
                        //       vertical: 40,
                        //     ), // adjusted for better look
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    HexColor('#124074'),
                                    HexColor('#332677'),
                                    HexColor('#124074'),
                                    HexColor('#0D1250'),
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: _isVerifying
                                    ? null
                                    : _onContinuePressed,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                child: _isVerifying
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _isResending ? null : _onResendCodePressed,
                          child: _isResending
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black54,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Resend Code',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
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
