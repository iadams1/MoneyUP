import 'package:flutter/material.dart';
import 'package:moneyup/services/supabase_service.dart';
import '/features/auth/screens/info.dart';
import 'package:moneyup/features/auth/screens/signup.dart';
import 'package:moneyup/shared/widgets/error_system.dart';     // ← Add this import

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _onGetStartedPressed() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Optional: Final sync before continuing
      await SupabaseService().syncAll();

      if (!mounted) return;

      // Navigate to Plaid Connect screen (main flow)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        ),
        (route) => false,
      );

      // Optional: If you still want to show InfoScreen after Plaid
      // Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoScreen()));

    } catch (e) {
      debugPrint('Error during confirmation flow: $e');

      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to prepare your account. Please try again.';
        });

        _showErrorDialog('Failed to prepare your account. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ErrorDialog(
        title: 'Setup Error',
        message: message,
        buttonText: 'Try Again',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/mu_bg.png',
            fit: BoxFit.fill,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 190.0, left: 55.0, right: 55.0),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/mu_check.png',
                    width: 240,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 40.0),
                  const Text(
                    'VERIFIED!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'Cha Ching! You have successfully verified your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 60.0),

                  // Show error message if any (optional inline display)
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),

                  // Get Started Button
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _onGetStartedPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Text(
                                'Get Started',
                                style: TextStyle(fontSize: 18),
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