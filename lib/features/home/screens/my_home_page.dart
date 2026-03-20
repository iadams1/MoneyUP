import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:moneyup/features/home/widgets/greeting_text.dart';
import 'package:moneyup/shared/widgets/first_time_plaid_connect.dart';
import 'package:moneyup/features/budgettracker/ui/time_filter.dart';
import 'package:moneyup/features/budgettracker/utils/time_range.dart';
import 'package:moneyup/features/home/widgets/monthly_spending_overview_view.dart';
import 'package:moneyup/features/home/widgets/no_spending_overview.dart';
// import '/shared/widgets/profile_menu_card.dart';
import '../widgets/budget_view.dart';
import '../widgets/no_budget_view.dart';
import 'package:moneyup/shared/widgets/notification_dialog.dart';
import 'package:moneyup/shared/widgets/profile_menu_card.dart';
import '/features/mywallet/screens/my_wallet.dart';
import '../widgets/primary_card_view.dart';
import '/models/budget.dart';
import '/models/linked_card.dart';
import '/services/service_locator.dart';
import '/shared/screen/loading_screen.dart';
import '/shared/widgets/bottom_nav.dart';
import '/core/utils/formatters.dart';
import '/shared/widgets/streak_banner.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  Budget? _budget;
  String? _name;
  List<LinkedCard> _cards = [];
  bool _hasCheckedPlaidDialog = false;
  int _currentStreak = 0;
  int _longestStreak = 0;
  List<bool> _weekLogins = List.filled(7, false);


  Map<int, double> spendingData = {};
  Map<int, String> categoryTitles = {};
  //bool _hasShownHomeNotification = false;

  @override
  void initState() {
    super.initState();
    _init();
    loadMonthlySpendingData();
  }

  Future<void> _init() async {
    try {
      // Start loading
      setState(() => _isLoading = true);

      final user = supabaseService.currentUserId;
      if (user != null) {
        try {
          await supabaseService.syncAll();
        } catch (e) {
          debugPrint("syncAll skipped: $e");
        }
      }

      profileService.loadProfileIcon();
      await _loadHome();
      _loadStreakData();
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

  Future<void> _loadStreakData() async {
    try {
      final shouldShowBanner = await streakService.recordUserStreak();
      final streak = await streakService.fetchUserStreak();
      final weekLogins = await streakService.fetchWeekLogins();

      if (!mounted) return;

      setState(() {
        _currentStreak = streak.currentStreak;
        _longestStreak = streak.longestStreak;
        _weekLogins = weekLogins;
      });

      if (shouldShowBanner) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          StreakBanner.showStreakBanner(
            context,
            currentStreak: _currentStreak,
            longestStreak: _longestStreak,
            weekLogins: _weekLogins,
          );
        });
      }
    } catch (e) {
      debugPrint('Error loading streak data: $e');
    }
  }

  Future<void> _loadHome() async {
    try {
      final budget = await budgetService.getRandomBudget();
      final cards = await walletService.fetchLinkedCards();
      final name = await profileService.getUserName();

      if (!mounted) return;

      setState(() {
        _budget = budget;
        _cards = cards;
        _name = name;
        _isLoading = false;
      });

      // ADD TEST NOTIFICATION HERE – after loading completes

      if (!_hasCheckedPlaidDialog) {
        _hasCheckedPlaidDialog = true;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;
          await _maybeShowPlaidDialog();
        });
      }
    } catch (e) {
      debugPrint('Error loading budgets: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _maybeShowPlaidDialog() async {
    final hasSeen = await profileService.hasSeenPlaidConnectDialog();
    if (!mounted || hasSeen == true) return;

    await showFirstTimePlaidConnect(context);
  }

  Future<void> loadMonthlySpendingData() async {
    final range = getTimeRange(TimeFilter.thisMonth, DateTime.now());

    final response = await budgetService.getMonthlySpending(
      start: range.start,
      end: range.end,
    );

    final Map<int, double> tempData = {};
    final Map<int, String> titlesById = {};

    for (final row in response) {
      final id = row['category_id'] as int;
      final title = Formatters.formatCategoryTitle(row['category_title']);
      final total = (row['total_spent'] as num).toDouble();

      tempData[id] = total;
      titlesById[id] = title;
    }

    if (!mounted) return;
    setState(() {
      spendingData = tempData;
      categoryTitles = titlesById;
    });
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
      height: 140,
      width: 380,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: budget == null
            ? const NoBudgetView()
            : BudgetView(budget: budget),
      ),
    );
  }

  Widget _buildSpendingOverview(BuildContext context) {
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
      height: 188,
      width: 380,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: spendingData.isEmpty
            ? NoSpendingOverview()
            : MonthlySpendingOverviewView(
                spendingData: spendingData,
                categoryTitles: categoryTitles,
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, {required Key key}) {
    final displayName = _name ?? "Guest";

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
              Row(
                children: [
                  ProfileMenuCard(),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text for time
                      GreetingText(
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                      // Text for username
                      SizedBox(
                        width: 230,
                        child: Text(
                          displayName,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 29,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const NotificationDialog(),
                    );
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
          Positioned(
            left: 0,
            right: 0,
            top: 170,
            bottom: 0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
                color: HexColor("0D1250"),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                child: Text(
                  Formatters.getFormattedDate(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 30,
            bottom: 0,
            child: SafeArea(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50.0),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 5.5),
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
                                      height: 217,
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
                              height: 243,
                              width: 330,
                              child: PrimaryCardView(cards: _cards),
                            ),
                          ],
                        ),
                      ),

                      // Article Card Widget

                      const SizedBox(height: 10),

                      // Budget Card Widget
                      _buildBudgetCard(context),

                      const SizedBox(height: 30),

                      // Monthly Spending Overview Widget
                      _buildSpendingOverview(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}