import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moneyup/core/config/supabase_config.dart';
import 'package:moneyup/features/auth/screens/verification.dart';
import 'package:moneyup/features/auth/screens/welcome.dart';
import 'package:moneyup/features/home/screens/my_home_page.dart';
import 'package:moneyup/shared/widgets/test_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moneyup/features/auth/screens/signup.dart';
import 'package:moneyup/features/auth/screens/login.dart';
import 'package:moneyup/services/plaid_service.dart';
import 'package:moneyup/services/notification_service.dart';
import 'package:moneyup/services/plaid_listener_service.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void getToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  debugPrint("FCM TOKEN: $token");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await NotificationService().initialize();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  PlaidListenerService().init();

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? true;

  runApp(MyApp(showHome: hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({super.key, required this.showHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: appNavigatorKey,
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
        '/welcome': (context) => const WelcomeScreen(),
        '/preview': (context) => const PreviewScreen(),
      },
      initialRoute: '/preview',
    );
  }
}
