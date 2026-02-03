import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:moneyup/services/auth_service.dart';

import 'package:moneyup/main.dart';
import 'package:moneyup/start/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}



class _LoginState extends State<LoginScreen> {

  Map userData = {};
  final _formkey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // STEP 1: Insert "Form" here, right before the Stack
      body: Form(
        key: _formkey, // Connect your key here
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset( // BACKGROUND
              'assets/images/mu_bg.png',
              fit: BoxFit.fill
            ),
            Container( // LOGIN IMAGE
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 120),
              child: Image.asset(
                'assets/images/mu_login.png',
                width: 350,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
            Align( // LOGIN SCREEN BOX
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding( // EMAIL ADDRESS
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
                                prefixIcon: Icon(Icons.email_outlined, color: Colors.black,),
                                filled: true,
                                fillColor: HexColor('#E7E7E7'),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(9.0))
                                ),
                              )
                            )
                          ),
                          Padding( // PASSWORD ENTRY
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true, // Hide password characters
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Enter password'),
                                MinLengthValidator(8, errorText: 'Password must be at least 8 characters'),
                              ]).call,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline, color: Colors.black),
                                filled: true,
                                fillColor: HexColor('#E7E7E7'),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(9.0))
                                ),
                              ),
                            ),
                          ),
                          Padding( // LOGIN BUTTON
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                gradient: LinearGradient(
                                  colors: [HexColor('#124074'), HexColor('#332677')],
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) { // This now works because of the Form wrapper
                                    try {
                                      await _authService.login(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text.trim(),
                                      );
                                    } catch (e) {
                                      if (mounted) { // Fixes blue underline
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      }
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                child: Text('Login', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                          // ... Sign up link code ...
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ), // STEP 2: Close the Form here
    );
  }
}