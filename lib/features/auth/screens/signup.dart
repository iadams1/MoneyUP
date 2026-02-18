import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/features/auth/screens/confirmation.dart';
import '/features/auth/screens/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/mu_bg.png', fit: BoxFit.fill),
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 50.0),
            child: Image.asset(
              'assets/images/mu_signup.png',
              width: 350,
              height: 350,
              fit: BoxFit.contain,
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
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 12),
                        Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                                child: TextFormField(
                                  controller: _nameController,
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'Enter your name'),
                                    MinLengthValidator(3, errorText: 'Minimum 3 characters'),
                                  ]).call,
                                  decoration: InputDecoration(
                                    hintText: 'Full Name',
                                    labelText: 'Full Name',
                                    prefixIcon: const Icon(Icons.create_outlined, color: Colors.black),
                                    filled: true,
                                    fillColor: HexColor('#E7E7E7'),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                                child: TextFormField(
                                  controller: _usernameController,
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'Enter your username'),
                                    MinLengthValidator(3, errorText: 'Minimum 3 characters'),
                                  ]).call,
                                  decoration: InputDecoration(
                                    hintText: 'Username',
                                    labelText: 'Username',
                                    prefixIcon: const Icon(Icons.person_outline, color: Colors.black),
                                    filled: true,
                                    fillColor: HexColor('#E7E7E7'),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                                child: TextFormField(
                                  controller: _emailController,
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'Enter email address'),
                                    EmailValidator(errorText: 'Invalid email address'),
                                  ]).call,
                                  decoration: InputDecoration(
                                    hintText: 'Email Address',
                                    labelText: 'Email Address',
                                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.black),
                                    filled: true,
                                    fillColor: HexColor('#E7E7E7'),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                                child: TextFormField(
                                  controller: _passwordController,
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'Enter password'),
                                    MinLengthValidator(8, errorText: 'Minimum 8 characters'),
                                  ]).call,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    labelText: 'Password',
                                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
                                    filled: true,
                                    fillColor: HexColor('#E7E7E7'),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                                child: TextFormField(
                                  controller: _confirmController,
                                  obscureText: true,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) return 'Re-type password';
                                    if (val != _passwordController.text) return 'Passwords do not match';
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Re-type Password',
                                    labelText: 'Re-type Password',
                                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
                                    filled: true,
                                    fillColor: HexColor('#E7E7E7'),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0, left: 12.0, right: 12.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                                    gradient: LinearGradient(
                                      colors: [HexColor('#124074'), HexColor('#332677')],
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formkey.currentState!.validate()) {
                                        try {
                                          final response = await Supabase.instance.client.auth.signUp(
                                            email: _emailController.text.trim(),
                                            password: _passwordController.text.trim(),
                                            data: {
                                              'full_name': _nameController.text.trim(),
                                              'username': _usernameController.text.trim()
                                            },
                                          );

                                          final user = response.user;
                                          if (user != null) 
                                          {
                                          }

                                          if (mounted) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ConfirmationScreen(),//VerificationScreen(email: _emailController.text.trim()),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Signup Failed: ${e.toString()}')),
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Already have an account? ',
                                      style: const TextStyle(fontSize: 15, color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: 'Login',
                                          style: TextStyle(color: HexColor('#7247B8'), fontWeight: FontWeight.bold),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}