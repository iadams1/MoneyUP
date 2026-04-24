import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '/features/auth/screens/signup.dart';
import '/features/home/screens/my_home_page.dart';
import '/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moneyup/shared/widgets/plaid_connect_dialog.dart';
import 'package:moneyup/shared/widgets/error_system.dart';     // ← Add this import

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    if (!(_formkey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      await AuthService().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      // Refresh session to ensure we have the latest user
      await Supabase.instance.client.auth.refreshSession();

      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        throw Exception("Login succeeded but no user session found");
      }

      debugPrint('Logged in successfully as user: ${currentUser.id}');

      // Check if user has connected a bank
      bool hasConnected = false;
      try {
        final response = await Supabase.instance.client
            .from('profiles')
            .select('has_plaid_connected')
            .eq('id', currentUser.id)
            .maybeSingle();

        hasConnected = response?['has_plaid_connected'] == true;
      } catch (e) {
        debugPrint('Error checking plaid flag: $e');
        hasConnected = false; // Fail open → show Plaid screen
      }

      // Navigate based on Plaid connection status
      if (hasConnected) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage(title: '')),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } on AuthException catch (e) {
      _showErrorDialog(e.message);
    } catch (e) {
      _showErrorDialog('Something went wrong. Please try again.');
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
        title: 'Login Failed',
        message: message,
        buttonText: 'Try Again',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/mu_bg.png', fit: BoxFit.fill),
            Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 120),
              child: Image.asset(
                'assets/images/mu_login.png',
                width: 350,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email Field
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              controller: _emailController,
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Enter email address'),
                                EmailValidator(errorText: 'Invalid email address. Please try again.'),
                              ]).call,
                              decoration: InputDecoration(
                                hintText: 'Email Address',
                                labelText: 'Email Address',
                                labelStyle: const TextStyle(
                                  color: Color(0x4F000000),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'SF Pro',
                                ),
                                prefixIcon: const Icon(Icons.email_outlined, color: Colors.black),
                                errorStyle: const TextStyle(fontSize: 16.0),
                                filled: true,
                                fillColor: HexColor('#E7E7E7'),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                              ),
                            ),
                          ),

                          // Password Field
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Enter password'),
                                MinLengthValidator(8, errorText: 'Password must be at least 8 characters'),
                              ]).call,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  color: Color(0x4F000000),
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'SF Pro',
                                ),
                                prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
                                errorStyle: const TextStyle(fontSize: 16.0),
                                filled: true,
                                fillColor: HexColor('#E7E7E7'),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(9.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Login Button
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
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
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                    ),
                            ),
                          ),

                          // Sign up link
                          Center(
                            child: Container(
                              padding: const EdgeInsets.only(top: 40),
                              child: RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: 'SF Pro',
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Sign up',
                                      style: TextStyle(
                                        color: HexColor('#7247B8'),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SF Pro',
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const SignUpScreen(),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}