import 'package:flutter/material.dart';
import 'package:moneyup/budgetTracker/budget_home.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:moneyup/services/plaid_connect.dart';
import 'package:moneyup/start/signup.dart';
import 'package:moneyup/start/login.dart';
import 'package:moneyup/transactions/transactions_home.dart';
import 'package:moneyup/education/education.dart';
import 'package:moneyup/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
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
      routes: {
        '/': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MyHomePage(title: 'MoneyUP'),
        '/plaid-connect': (context) => PlaidConnectScreen(),
      },
      initialRoute: '/',
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
  late Future<Map<String, dynamic>?> _randomBudget;

  @override
  void initState() {
    super.initState();
    _randomBudget = getRandomBudget();
  }

  Future<Map<String, dynamic>?> getRandomBudget() async {
    try {
      final response = await Supabase.instance.client
          .rpc('get_random_budget', params: {'p_user_id': 1001});

      debugPrint("RPC response: $response");

      if (response == null) return null;
      if (response is List && response.isEmpty) return null;

      return (response as List).first as Map<String, dynamic>;
    } catch (e) {
      debugPrint("RPC ERROR: $e");
      rethrow;
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
              Container(
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
            child: Image.asset(
              'assets/images/mu_bg.png',
              fit: BoxFit.fill
            ),
          ),
          SafeArea(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  FutureBuilder<Map<String, dynamic>?>(
                    future: _randomBudget,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data == null) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text("No budgets available."),
                        );
                      }

                      final budget = snapshot.data!;
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(16, 0, 0, 0),
                                offset: Offset(0, 8),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        height: 160,
                        width: 380,
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    height: 140,
                                    child: CircularPercentIndicator(
                                      radius: 60,
                                      lineWidth: 18,
                                      percent:
                                          (budget["AmountSaved"] / budget["Goal"]).clamp(0.0, 1.0),
                                      center: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${((budget["AmountSaved"] / budget["Goal"]) * 100).clamp(0.0, 100.0).toStringAsFixed(0)}%",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: const Color.fromARGB(6, 0, 0, 0,),
                                      progressColor: Color.fromRGBO(47, 52, 126, 100),
                                      circularStrokeCap: CircularStrokeCap.round,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 30),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 0),
                                    Text(
                                      budget["Title"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(200),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (_) => BudgetGoalPage(),
                                          ),
                                        );
                                      },
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color.fromRGBO(25, 50, 100, 100), Color.fromRGBO(47, 52, 126, 100)],
                                          ),
                                          borderRadius: BorderRadius.circular(200),
                                        ),
                                        child: Container(
                                          width: 220,
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'See All',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18
                                            ),
                                          ),
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ],
              )
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
              icon: Image.asset('assets/icons/homeIcon.png'),
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
              icon: Image.asset('assets/icons/unselectedSettingsIcon.png'),
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