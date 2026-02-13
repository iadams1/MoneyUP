import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hexcolor/hexcolor.dart';
<<<<<<< HEAD:lib/start/login.dart
=======
import 'package:moneyup/features/auth/screens/signup.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:moneyup/features/home/screens/my_home_page.dart';
>>>>>>> 1a5ac9c (Finished the MyWallet screens and added widgets to the home screen. Also moved the home screen to its own folder.):lib/features/auth/screens/login.dart
import 'package:moneyup/services/auth_service.dart';
import 'package:moneyup/start/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}



class _LoginState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Enter password'),
                              MinLengthValidator(8, errorText: 'Password must be at least 8 characters'),
                              PatternValidator(r'(?=.*?[#!@$%^&*-])', errorText: 'Invalid password')
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
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MyHomePage(title: '',)),
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
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}