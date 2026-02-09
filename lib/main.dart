import 'package:flutter/material.dart';
import 'package:moneyup/core/config/supabase_config.dart';
import 'package:moneyup/features/education/screens/education.dart';
import 'package:moneyup/features/proflie/screens/profile.dart';
import 'package:moneyup/features/transactions/screens/transactions_home.dart';
import 'package:moneyup/shared/screen/loading_screen.dart';
import 'package:moneyup/models/budget.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:moneyup/features/budgettracker/widgets/budget_view.dart';
import 'package:moneyup/features/budgettracker/widgets/no_budget_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moneyup/features/auth/screens/signup.dart';
import 'package:moneyup/features/auth/screens/login.dart';
import 'package:moneyup/services/plaid_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

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
      initialRoute: '/home',
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
  bool _isLoading = true;
  Budget? _budget; 

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      // Start loading
      setState(() => _isLoading = true);

      final user = supabaseService.currentUserId;
      if (user != null) {
        // await it so errors are caught
        await supabaseService.syncAll();
      }

      await _loadHome();
    } catch (e, st) {
      debugPrint('Home init error: $e');
      debugPrintStack(stackTrace: st);

      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Home failed: $e')),
      );
    }
  }


  Future<void> _loadHome() async {
    try {
      final budget = await budgetService.getRandomBudget();

      if (!mounted) return;

      setState(() {
        _budget = budget;
        _isLoading = false;
      });

    } catch (e) {
      debugPrint('Error loading budgets: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _isLoading
          ? const LoadingScreen(key: ValueKey('loading'))
          : _buildContent(context, key: const ValueKey('content')),
    );
  }

  Widget _buildBudgetCard(BuildContext context) {
    final budget = _budget;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(16, 0, 0, 0),
            offset: Offset(0, 8),
            blurRadius: 12,
          ),
        ],
      ),
      height: 160,
      width: 380,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: budget == null
            ? const NoBudgetView()
            : BudgetView(budget: budget),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required Key key}) {
    return Scaffold(
      key: key,
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
                  _buildBudgetCard(context),
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