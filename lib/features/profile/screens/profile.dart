import 'package:flutter/material.dart';
import 'package:moneyup/shared/widgets/error_system.dart';

import '/services/service_locator.dart';
import '/shared/contrants/user_icons.dart';
import '/features/profile/widgets/profile_menu.dart';
import '/shared/widgets/app_avatar.dart';
import '/shared/widgets/logout_dialog.dart';
import '/shared/utils/show_notification_dashboard.dart';
import '/shared/widgets/bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedUserIndex = 12;
  bool _isSaving = false;
  bool _showEditAccount = false;

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
                    showNotificationDropdown(context);
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
        toolbarHeight: 130,
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
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
                children: [
                  const SizedBox(height: 20),
                  ProfileMenu(
                    text: 'Edit Account',
                    trailing: Icon(
                      _showEditAccount 
                        ? Icons.keyboard_arrow_up_outlined 
                        : Icons.keyboard_arrow_down_outlined
                    ),
                    press: () {
                      setState(() {
                        _showEditAccount = !_showEditAccount;
                      });
                    },
                  ),
                  AnimatedCrossFade(
                    crossFadeState: _showEditAccount
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                    duration: Duration(microseconds: 250),
                    firstChild: Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: UserImages.all.length - 1,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                              ),
                              itemBuilder: (context, i) {
                                final bool isSelected = i == _selectedUserIndex;
                  
                                return InkWell(
                                  onTap: () => setState(() => _selectedUserIndex = i),
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                    scale: isSelected ? 1.1 : 1.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(500),
                                        border: Border.all(
                                          width: 2,
                                          color: isSelected
                                              ? const Color.fromARGB(255, 255, 255, 255)
                                              : const Color.fromARGB(0, 255, 255, 255),
                                        ),
                                        color: const Color.fromARGB(0, 255, 255, 255),
                                      ),
                                      child: Image.asset(UserImages.all[i]),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: _isSaving
                                  ? null
                                  : () async {
                                    try {
                                      setState(() => _isSaving = true);
            
                                      await profileService.saveProfileSelection(
                                        profileIconId: _selectedUserIndex,
                                      );
          
                                      if (!mounted) return;
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              "Success",
                                              textAlign: TextAlign.center,
                                            ),
                                            content: Text(
                                              'Profile icon successfully updated!',
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context), 
                                                child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    fontFamily: 'SF Pro',
                                                    color: Colors.deepPurpleAccent,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } catch (e) {
                                      showDialog(
                                        context: context,
                                        builder: (_) => ErrorDialog(
                                          message: "Failed to save profile: $e", 
                                          onButtonPressed: () => Navigator.pop(context),
                                        ),
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isSaving = false);
                                      }
                                    }
                                  },
                                child: _isSaving
                                  ? CircularProgressIndicator()
                                  : Text('Save')
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    secondChild: SizedBox.shrink(),
                  ),
                  ProfileMenu(
                    text: 'Reset Password',
                    trailing: Icon(
                      _showEditAccount 
                        ? Icons.keyboard_arrow_right_outlined 
                        : Icons.keyboard_arrow_down_outlined
                    ),
                    press: () => {}
                  ),
                  ProfileMenu(
                    text: 'Change Theme', 
                    trailing: Icon(
                      _showEditAccount 
                        ? Icons.keyboard_arrow_right_outlined 
                        : Icons.keyboard_arrow_down_outlined
                    ),
                    press: () => {}
                  ),
                  ProfileMenu(
                    text: 'Language', 
                    trailing: Icon(
                      _showEditAccount 
                        ? Icons.keyboard_arrow_right_outlined 
                        : Icons.keyboard_arrow_down_outlined
                    ),
                    press: () => {}),
                  ProfileMenu(
                    text: 'Currency', 
                    trailing: Icon(
                      _showEditAccount 
                        ? Icons.keyboard_arrow_right_outlined 
                        : Icons.keyboard_arrow_down_outlined
                    ),
                    press: () => {}),
                  ProfileMenu(
                    text: 'Help & Support',
                    trailing: Icon(
                      _showEditAccount 
                        ? Icons.keyboard_arrow_right_outlined 
                        : Icons.keyboard_arrow_down_outlined
                    ),
                     press: () => {}),
                  ProfileMenu(
                    text: 'Terms and Conditions', 
                    trailing: Icon(
                      _showEditAccount 
                        ? Icons.keyboard_arrow_right_outlined 
                        : Icons.keyboard_arrow_down_outlined
                    ),
                    press: () => {}),
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
                          await LogoutDialog.show(context);
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
