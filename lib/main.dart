import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:moneyup/transactions/transactions_home.dart';
import 'package:moneyup/education/education.dart';
import 'package:moneyup/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Supabase.initialize(
    url: 'https://dnzgsfovhbxsxlbpvzbt.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRuemdzZm92aGJ4c3hsYnB2emJ0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg1ODg3MDEsImV4cCI6MjA3NDE2NDcwMX0.B6wXycYdEY_HFiML1CVVaEW-IF4qWwmYPdgynUcyghQ',
  );

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? true;

  runApp(MyApp(showHome: hasSeenOnboarding));
}

enum BudgetType {
  food("Food & Dining"),
  entertainment("Entertainment & Leisure"),
  transportation("Transportation"),
  shopping("Shopping & Personal"),
  housing("Housing & Utilities");

  final String label;
  const BudgetType(this.label);
}

class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({super.key, required this.showHome});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'MoneyUP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: EducationScreen(),
      // home: showHome ? const MyHomePage(title: 'MoneyUP') : const WelcomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Future<void> _resetOnboarding(BuildContext context) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('hasSeenOnboarding', false);

  //   if (context.mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Onboarding reset. Restarting...'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );

  //     // Wait a bit for the SnackBar, then go to onboarding
  //     await Future.delayed(const Duration(seconds: 2));
  //     Navigator.pushReplacement(
  //       // ignore: use_build_context_synchronously
  //       context,
  //       MaterialPageRoute(builder: (_) => const WelcomeScreen()),
  //     );
  //   }
  // }

  int get _selectedIndex => 0;

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
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        height: 80,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage(title: ''))
              );
            break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => TransactionsHome())
              );
            break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => EducationScreen())
              );
            break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen())
              );
            break;
          }
        }, 
        indicatorColor: Colors.transparent,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.grey[400],
              size: 35
            ),
            selectedIcon: Icon(
              Icons.home_outlined,
              color: HexColor('#0F52BA'),
              size: 35
            ), 
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.credit_card_outlined,
              color: Colors.grey[400],
              size: 35
            ), 
            selectedIcon: Icon(
              Icons.credit_card_outlined,
              color: HexColor('#0F52BA'),
              size: 35
            ), 
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.menu_book_outlined,
              color: Colors.grey[400],
              size: 35
            ), 
            selectedIcon: Icon(
              Icons.menu_book_outlined,
              color: HexColor('#0F52BA'),
              size: 35
            ), 
            label: '',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
              color: Colors.grey[400],
              size: 35
            ),
            selectedIcon: Icon(
              Icons.person_outline,
              color: HexColor('#0F52BA'),
              size: 35
            ), 
            label: '',
          ),
        ],
      ),
    );
  }
}