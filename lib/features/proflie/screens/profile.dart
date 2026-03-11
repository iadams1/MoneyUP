import 'package:flutter/material.dart';
import 'package:moneyup/features/auth/screens/login.dart'; //LoginScreen
import 'package:moneyup/features/education/screens/education.dart';
import 'package:moneyup/features/home/screens/my_home_page.dart';
import 'package:moneyup/features/transactions/screens/transactions_home.dart';
import 'package:moneyup/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggingOut = false;
  final AuthService _authService = AuthService();

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);

    try {
      await _authService.signOut();

      if (!mounted) return;

      // Clear navigation stack and go to login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // removes all previous routes
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(top: 10, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(0, 255, 255, 255),
                  border: Border.all(
                    width: 3,
                    color: const Color.fromARGB(255, 121, 121, 121),
                  ),
                ),
                child: Image.asset('assets/icons/profileIcon.png'),
              ),
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.all(5),
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement notifications
                  },
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        toolbarHeight: 120,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/mu_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ProfileMenu(text: 'Edit Account', press: () {}),
                    ProfileMenu(text: 'Reset Password', press: () {}),
                    ProfileMenu(text: 'Change Theme', press: () {}),
                    ProfileMenu(text: 'Language', press: () {}),
                    ProfileMenu(text: 'Currency', press: () {}),
                    ProfileMenu(text: 'Help & Support', press: () {}),
                    ProfileMenu(text: 'Terms and Conditions', press: () {}),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 370,
                      child: ElevatedButton(
                        onPressed: _isLoggingOut ? null : _handleLogout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromRGBO(25, 50, 100, 1),
                                Color.fromRGBO(47, 52, 126, 1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: _isLoggingOut
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      "Logout",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
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
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(0, 255, 253, 249),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Image.asset('assets/icons/unselectedHomeIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => MyHomePage(title: 'MoneyUp'),
                  ),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/unselectedTransactionsIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => TransactionsHome()),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/unselectedEducationIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => EducationScreen()),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/settingsIcon.png'),
              onPressed: () {
                // Already on profile → no navigation needed
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final String text;
  final VoidCallback? press;

  const ProfileMenu({super.key, required this.text, this.press});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ElevatedButton(
        onPressed: press,
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromARGB(16, 0, 0, 0),
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black),
          ],
        ),
      ),
    );
  }
}