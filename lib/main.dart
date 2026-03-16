import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '/core/config/supabase_config.dart';
import '/features/auth/screens/verification.dart';
import '/features/home/screens/my_home_page.dart';
import '/features/auth/screens/signup.dart';
import '/features/auth/screens/login.dart';
import '/services/plaid_service.dart';
import '/services/notification_service.dart'; //custom
import '/services/realtime_notifications.dart';

void getToken() async 
{
  String? token = await FirebaseMessaging.instance.getToken();
  // print("FCM TOKEN: $token");
}

void startRealtime() 
{
  final user = Supabase.instance.client.auth.currentUser;

  if (user != null) {
    RealtimeNotificationService().startListening(user.id);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");

  // Initialize notifications first
  await NotificationService().initialize();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? true;

  runApp(MyApp(showHome: hasSeenOnboarding));

  startRealtime();
}

class MyApp extends StatelessWidget {
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
        '/': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MyHomePage(title: 'MoneyUP'),
        '/plaid-connect': (context) => const PlaidService(),
        '/verify': (context) => const VerificationScreen(email: ''),
      },
      initialRoute: '/home',
    );
  }
}