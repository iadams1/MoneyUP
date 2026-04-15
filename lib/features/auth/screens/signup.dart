import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:moneyup/features/auth/screens/login.dart';
import 'package:moneyup/features/auth/screens/verification.dart';
import 'package:moneyup/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final AuthService _authService = AuthService();

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
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 50),
                  child: Image.asset(
                    'assets/images/mu_signup.png',
                    width: 350,
                    height: 350,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            hint: 'Full Name',
                            icon: Icons.create_outlined,
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Enter your name'),
                              MinLengthValidator(3, errorText: 'Minimum 3 characters'),
                            ]).call,
                          ),
                          _buildTextField(
                            controller: _usernameController,
                            label: 'Username',
                            hint: 'Username',
                            icon: Icons.person_outline,
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Enter your username'),
                              MinLengthValidator(3, errorText: 'Minimum 3 characters'),
                            ]).call,
                          ),
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email Address',
                            hint: 'Email Address',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Enter email address'),
                              EmailValidator(errorText: 'Invalid email address'),
                            ]).call,
                          ),
                          _buildTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Password',
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey[700],
                              ),
                              onPressed: () => setState(() {
                                _obscurePassword = !_obscurePassword;
                              }),
                            ),
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'Enter password'),
                              MinLengthValidator(8, errorText: 'Minimum 8 characters'),
                            ]).call,
                          ),
                          _buildTextField(
                            controller: _confirmController,
                            label: 'Re-type Password',
                            hint: 'Re-type Password',
                            icon: Icons.lock_outline,
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.grey[700],
                              ),
                              onPressed: () => setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              }),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'Re-type password';
                              if (val != _passwordController.text) return 'Passwords do not match';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildGradientButton(
                            text: 'Sign Up',
                            onPressed: _handleSignUp,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30, bottom: 20),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Already have an account? ',
                                  style: const TextStyle(fontSize: 15, color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: 'Login',
                                      style: TextStyle(
                                        color: HexColor('#7247B8'),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                                            ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: HexColor('#E7E7E7'),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(9.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [HexColor('#124074'), HexColor('#332677')]),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(child: Text(text, style: const TextStyle(color: Colors.white))),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _nameController.text.trim(),
        username: _usernameController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationScreen(email: _emailController.text.trim()),
        ),
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e'), backgroundColor: Colors.red),
      );
    }
  }
}