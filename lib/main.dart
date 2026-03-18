import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moneyup/core/config/supabase_config.dart';
import 'package:moneyup/features/auth/screens/user_select.dart';
import 'package:moneyup/features/auth/screens/verification.dart';
import 'package:moneyup/features/auth/screens/welcome.dart';
import 'package:moneyup/features/home/screens/my_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moneyup/features/auth/screens/signup.dart';
import 'package:moneyup/features/auth/screens/login.dart';
import 'package:moneyup/services/plaid_service.dart';
import 'package:moneyup/services/notification_service.dart';

void getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM TOKEN: $token"); //Debug
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  //Initialize notifications FIRST
  await NotificationService().initialize();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding =
      prefs.getBool('hasSeenOnboarding') ?? true;

  runApp(MyApp(showHome: hasSeenOnboarding));
}

class MyApp extends StatelessWidget 
{
  final bool showHome;
  const MyApp({super.key, required this.showHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyUP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: "SF Pro",
      ),
      routes: {
        '/verification': (context) => const VerificationScreen(email: ''),
        '/': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MyHomePage(title: 'MoneyUP'),
        '/plaid-connect': (context) => const PlaidService(),
        '/verify': (context) => const VerificationScreen(email: ''),
        '/user': (context) => const UserSelectScreen(),
        '/start': (context) => const WelcomeScreen(),
      },
      initialRoute: '/login',
    );
  }
}
