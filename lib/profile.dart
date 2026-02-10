import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:moneyup/education/education.dart';
import 'package:moneyup/main.dart';
import 'package:moneyup/transactions/transactions_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.only(top: 10, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(0),
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
              Container( // NOTIFICATION ICON
                alignment: Alignment.topRight,
                padding: EdgeInsets.all(5),
                child: IconButton(
                  onPressed: () {
                    // print('Notification icon pressed');
                  }, 
                  icon: Icon(
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
            child: Image.asset( // BACKGROUND
              'assets/images/mu_bg.png',
              fit: BoxFit.fill
            ),
          ),
          SafeArea( // WHITE BOX CONTAINER
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50.0),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    ProfileMenu(
                      text: 'Edit Account',
                      press: () => {},
                    ),
                    ProfileMenu(
                      text: 'Reset Password',
                      press: () => {},
                    ),
                    ProfileMenu(
                      text: 'Change Theme',
                      press: () => {},
                    ),
                    ProfileMenu(
                      text: 'Language',
                      press: () => {},
                    ),
                    ProfileMenu(
                      text: 'Currency',
                      press: () => {},
                    ),
                    ProfileMenu(
                      text: 'Help & Support',
                      press: () => {},
                    ),
                    ProfileMenu(
                      text: 'Terms and Conditions',
                      press: () => {},
                    ),
                    Padding( // LOGIN BUTTON
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Log Out'),
                                content: const Text('Are you sure you want to log out?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Log Out', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed != true) return;

                            // Proceed with logout...
                            try {
                              await Supabase.instance.client.auth.signOut();
                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                              }
                            } catch (e) {
                              // error handling...
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: const Color.fromARGB(255, 144, 68, 232),
                          ),
                          child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                    builder: (_) => MyHomePage(title: 'MoneyUp',),
                  ),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/unselectedTransactionsIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => TransactionsHome(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/unselectedEducationIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => EducationScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/settingsIcon.png'),
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => ProfileScreen(),
                  ),
                );
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

  const ProfileMenu({
    super.key,
    required this.text,
    this.press,
  });

 @override
 Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 10),
    child: ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        foregroundColor: Color.fromARGB(16, 0, 0, 0),
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20
              )
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black)
        ],
      )
    ),
  );
 }
}