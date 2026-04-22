import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moneyup/shared/widgets/error_system.dart';

import '/features/auth/screens/signup.dart';
import '/features/home/screens/my_home_page.dart';
import '/services/auth_service.dart';
import 'package:moneyup/services/realtime_notifications.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Add password visibility state
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // BACKGROUND IMAGE
            Image.asset(
              'assets/images/mu_bg.png',
              fit: BoxFit.fill,
            ),
            // LOGIN IMAGE
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
            // LOGIN FORM BOX
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
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
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // EMAIL FIELD
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'Enter email address'),
                              EmailValidator(
                                  errorText:
                                      'Invalid email address. Please try again.'),
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
                              prefixIcon: const Icon(Icons.email_outlined,
                                  color: Colors.black),
                              errorStyle: const TextStyle(fontSize: 16.0),
                              filled: true,
                              fillColor: HexColor('#E7E7E7'),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9.0)),
                              ),
                            ),
                          ),
                        ),
                        // PASSWORD FIELD
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Enter password'),
                              MinLengthValidator(8,
                                  errorText:
                                      'Password must be at least 8 characters'),
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
                              prefixIcon:
                                  const Icon(Icons.lock_outline, color: Colors.black),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              errorStyle: const TextStyle(fontSize: 16.0),
                              filled: true,
                              fillColor: HexColor('#E7E7E7'),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9.0)),
                              ),
                            ),
                          ),
                        ),
                        // LOGIN BUTTON
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      HexColor('#124074'),
                                      HexColor('#332677'),
                                      HexColor('#124074'),
                                      HexColor('#0D1250'),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // SIGNUP LINK
                        Center(
                          child: Padding(
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
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const SignUpScreen()),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
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

  // HANDLE LOGIN LOGIC
  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      await AuthService().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) throw Exception("Session not established after login");

      RealtimeNotificationService().startListening(session.user.id);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage(title: '')),
      );
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => ErrorDialog(
          title: 'Login Failed',
          message: 'Invalid email or password. Please try again.',
          buttonText: 'Try Again',
          onButtonPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}