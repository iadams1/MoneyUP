import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moneyup/shared/widgets/error_system.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:moneyup/features/auth/screens/verification.dart';
import 'package:moneyup/services/auth_service.dart';

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

  bool _nameError = false;
  bool _usernameError = false;
  bool _emailError = false;
  bool _passwordError = false;
  bool _confirmError = false;

  final AuthService _authService = AuthService();

  final MultiValidator _nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Enter your name'),
    MinLengthValidator(3, errorText: 'Minimum 3 characters'),
  ]);

  final MultiValidator _usernameValidator = MultiValidator([
    RequiredValidator(errorText: 'Enter your username'),
    MinLengthValidator(3, errorText: 'Minimum 3 characters'),
  ]);

  final MultiValidator _emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Enter email address'),
    EmailValidator(errorText: 'Invalid email address'),
  ]);

  final MultiValidator _passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Enter password'),
    MinLengthValidator(8, errorText: 'Minimum 8 characters'),
  ]);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final result = _nameValidator.call(value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _nameError = result != null);
      }
    });
    return result;
  }

  String? _validateUsername(String? value) {
    final result = _usernameValidator.call(value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _usernameError = result != null);
      }
    });
    return result;
  }

  String? _validateEmail(String? value) {
    final result = _emailValidator.call(value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _emailError = result != null);
      }
    });
    return result;
  }

  String? _validatePassword(String? value) {
    final result = _passwordValidator.call(value);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _passwordError = result != null);
      }
    });
    return result;
  }

  String? _validateConfirmPassword(String? value) {
    String? result;
    if (value == null || value.isEmpty) {
      result = 'Re-type password';
    } else if (value != _passwordController.text) {
      result = 'Passwords do not match';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _confirmError = result != null);
      }
    });

    return result;
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
                  padding: const EdgeInsets.only(top: 45),
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
                            validator: _validateName,
                            hasError: _nameError,
                          ),
                          _buildTextField(
                            controller: _usernameController,
                            label: 'Username',
                            hint: 'Username',
                            icon: Icons.person_outline,
                            validator: _validateUsername,
                            hasError: _usernameError,
                          ),
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email Address',
                            hint: 'Email Address',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            hasError: _emailError,
                          ),
                          _buildTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Password',
                            icon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            hasError: _passwordError,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey[700],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: _validatePassword,
                          ),
                          _buildTextField(
                            controller: _confirmController,
                            label: 'Re-type Password',
                            hint: 'Re-type Password',
                            icon: Icons.lock_outline,
                            obscureText: _obscureConfirmPassword,
                            hasError: _confirmError,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey[700],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                            validator: _validateConfirmPassword,
                          ),
                          const SizedBox(height: 20),
                          _buildGradientButton(
                            text: 'Sign Up',
                            onPressed: _handleSignUp,
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 20),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Already have an account? ',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
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
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const LoginScreen(),
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
    bool hasError = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black),
          suffixIcon: hasError
              ? const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                )
              : suffixIcon,
          filled: true,
          fillColor: HexColor('#E7E7E7'),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(9.0)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9.0),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
  }) {
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [HexColor('#124074'), HexColor('#332677')],
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
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
          builder: (_) => VerificationScreen(
            email: _emailController.text.trim(),
          ),
        ),
      );
    } on AuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}