import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:moneyup/start/verification.dart';

import 'package:moneyup/start/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpState();
}
  
class _SignUpState extends State<SignUpScreen> {
  Map userData = {};
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(// BACKGROUND
            'assets/images/mu_bg.png',
            fit: BoxFit.fill
          ),
          Container( // IMAGE CONTAINER
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 50.0),
            child: Image.asset(
              'assets/images/mu_signup.png',
              width: 350,
              height: 350,
              fit: BoxFit.contain,
            ),
          ),
          Align ( // SIGNUP BOX
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
                    padding: const EdgeInsets.all(12.0),
                    child: Column (
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(height: 12),
                        Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding( // NAME ENTRY
                                padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                                child: TextFormField(
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'Enter your name'),
                                    MinLengthValidator(3, errorText: 'Minimum 3 characters'),
                                  ]).call,
                                  decoration: InputDecoration(
                                    hintText: 'Full Name',
                                    labelText: 'Full Name',
                                    labelStyle: TextStyle(
                                      color: Color(0x4F000000),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SF Pro'
                                    ),
                                    prefixIcon: Icon(Icons.create_outlined, color: Colors.black),
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
                              Padding( // USERNAME ENTRY
                                padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                                child: TextFormField(
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'Enter your username'),
                                    MinLengthValidator(3, errorText: 'Minimum 3 characters'),
                                  ]).call,
                                  decoration: InputDecoration(
                                    hintText: 'Username',
                                    labelText: 'Username',
                                    labelStyle: TextStyle(
                                      color: Color(0x4F000000),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SF Pro'
                                    ),
                                    prefixIcon: Icon(Icons.person_outline, color: Colors.black,),
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
                              Padding( // EMAIL ADDRESS ENTRY
                                padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
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
                                    prefixIcon: Icon(Icons.email_outlined, color: Colors.black),
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
                              Padding( // PASSWORD ENTRY
                                padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
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
                                    prefixIcon: Icon(Icons.lock_outline, color: Colors.black,),
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
                              Padding( //2ND PASSWORD ENTRY
                                padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                                child: TextFormField(
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: 'Re-type password'),
                                    MinLengthValidator(8, errorText: 'Password must match'),
                                    PatternValidator(r'(?=.*?[#!@$%^&*-])', errorText: 'Invalid password')
                                  ]).call,
                                  decoration: InputDecoration(
                                    hintText: 'Re-type Password',
                                    labelText: 'Re-type Password',
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
                              Padding( // SIGNUP BUTTON
                                padding: const EdgeInsets.only(top: 20.0, left: 12.0, right: 12.0),
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
                                    onPressed: () {
                                      // if (_formkey.currentState!.validate()) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const VerificationScreen(email: '',))
                                        );
                                      // }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: const Color.fromARGB(255, 144, 68, 232),
                                    ),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'SF Pro'),
                                    ),
                                  ),
                                ),
                              ),
                              Center( // PUSH TO LOGIN SCREEN
                                child: Container(
                                  padding: EdgeInsets.only(top:30, bottom: 20),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Already have an account? ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Login',
                                          style: TextStyle(
                                            color: HexColor('#7247B8'),
                                            fontWeight: FontWeight.bold
                                          ),
                                          recognizer: TapGestureRecognizer()..onTap = () {
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