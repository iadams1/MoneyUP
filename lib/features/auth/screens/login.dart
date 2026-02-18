import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '/features/auth/screens/signup.dart';
import 'package:moneyup/features/home/screens/my_home_page.dart';
import 'package:moneyup/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Scaffold(
      body: Stack(
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
                              RequiredValidator(
                                errorText: 'Enter email address'),
                                EmailValidator(errorText: 'Invalid email address. Please try again.'),
                            ]).call,
                            decoration: InputDecoration(
                              hintText: 'Email Address',
                              labelText: 'Email Address',
                              labelStyle: TextStyle(
                                color: Color(0x4F000000),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'SF Pro'
                              ),
                              prefixIcon: Icon(Icons.email_outlined, color: Colors.black,),
                              errorStyle: TextStyle(fontSize: 16.0),
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
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Enter password'),
                              MinLengthValidator(8, errorText: 'Password must be at least 8 characters'),
                              //PatternValidator(r'(?=.*?[#!@$%^&*-])', errorText: 'Invalid password')
                            ]).call,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Color(0x4F000000),
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'SF Pro'
                              ),
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.black),
                              errorStyle: TextStyle(fontSize: 16.0),
                              filled: true,
                              fillColor: HexColor('#E7E7E7'),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(9.0))
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.only(left: 20),
                        //   child: Text('Forgot Password?'),
                        // ),
                        Padding( // LOGIN BUTTON
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
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
                            child:ElevatedButton(
                              onPressed: () async {
                                if (!(_formkey.currentState?.validate() ?? false)) return;

                                try {
                                  await AuthService().login(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  );

                                  if (!mounted) return;

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MyHomePage(title: ''),
                                    ),
                                  );
                                } catch (e) {
                                  debugPrint('LOGIN ERROR: $e');

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Invalid email or password')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: const Color.fromARGB(255, 144, 68, 232),
                              ),
                              child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Center( // PUSH TO SIGNUP SCREEN
                          child: Container(
                            alignment: FractionalOffset.bottomCenter,
                            padding: EdgeInsets.only(top: 40),
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontFamily: 'SF Pro'
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Sign up',
                                    style: TextStyle(
                                      color: HexColor('#7247B8'),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SF Pro'
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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