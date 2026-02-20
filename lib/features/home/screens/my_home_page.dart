import 'package:flutter/material.dart';
import 'package:moneyup/shared/widgets/app_avatar.dart';

import '/features/budgettracker/widgets/budget_view.dart';
import '/features/budgettracker/widgets/no_budget_view.dart';
import '/features/mywallet/screens/my_wallet.dart';
import '../widgets/primary_card_view.dart';
import '/models/budget.dart';
import '/models/linked_card.dart';
import '/services/service_locator.dart';
import '/shared/screen/loading_screen.dart';
import '/shared/widgets/bottom_nav.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  Budget? _budget;
  List<LinkedCard> _cards = [];

  @override
  void initState() {
    super.initState();
    _init();
    profileService.loadProfileIcon();
  }

  Future<void> _init() async {
    try {
      // Start loading
      setState(() => _isLoading = true);

      final user = supabaseService.currentUserId;
      if (user != null) {
        await supabaseService.syncAll();
      }

      await _loadHome();
    } catch (e, st) {
      debugPrint('Home init error: $e');
      debugPrintStack(stackTrace: st);

      if (!mounted) return;
      setState(() => _isLoading = false);

      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(SnackBar(content: Text('Home failed: $e')));
    }
  }

  Future<void> _loadHome() async {
    try {
      final budget = await budgetService.getRandomBudget();
      final cards = await walletService.fetchLinkedCards();

      if (!mounted) return;

      setState(() {
        _budget = budget;
        _cards = cards;
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
              AppAvatar(
                size: 60,
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
            child: Image.asset('assets/images/mu_bg.png', fit: BoxFit.fill),
          ),
          SafeArea(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: 12.5),
                  // MyWallet Card Widget
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 4, 25),
                          child: SizedBox(
                            width: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (_) => const MyWallet(),
                                  ),
                                );

                                await _init();
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromRGBO(25, 50, 100, 1),
                                      Color.fromRGBO(47, 52, 126, 1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const SizedBox(
                                  width: 70,
                                  height: 220,
                                  child: Center(
                                    child: Text(
                                      "+",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 250,
                          width: 330,
                          child: PrimaryCardView(cards: _cards),
                        ),
                      ],
                    ),
                  ),

                  // Article Card Widget

                  // Budget Card Widget
                  _buildBudgetCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
