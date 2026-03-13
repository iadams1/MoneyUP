import 'package:flutter/material.dart';
import 'package:moneyup/features/auth/screens/login.dart';
import 'package:moneyup/features/profile/widgets/profile_menu.dart';
import 'package:moneyup/services/auth_service.dart';
import 'package:moneyup/shared/widgets/app_avatar.dart';
import 'package:moneyup/shared/widgets/bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  Future<void> _handleLogout() async {
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
              AppAvatar(size: 60),
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
              // BACKGROUND
              'assets/images/mu_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                color: Colors.white,
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                children: [
                  const SizedBox(height: 20),
                  ProfileMenu(text: 'Edit Account', press: () => {}),
                  ProfileMenu(text: 'Reset Password', press: () => {}),
                  ProfileMenu(text: 'Change Theme', press: () => {}),
                  ProfileMenu(text: 'Language', press: () => {}),
                  ProfileMenu(text: 'Currency', press: () => {}),
                  ProfileMenu(text: 'Help & Support', press: () => {}),
                  ProfileMenu(text: 'Terms and Conditions', press: () => {}),
                  const SizedBox(height: 20),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text(
                                      'Log Out',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 27,
                                      ),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                      child: Text(
                                        'Are you sure you want to log out?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    actions: [
                                      Center(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                        255,
                                                        184,
                                                        27,
                                                        27,
                                                      ),
                                                  padding: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  // Proceed with logout...
                                                  _handleLogout();
                                                },
                                                child: const Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
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

                                if (confirmed != true) return;

                                // Proceed with logout...
                                _handleLogout();
                              },
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
                              child: Text(
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
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}
