import 'package:flutter/material.dart';
import 'package:moneyup/core/theme/colors.dart';
import 'package:moneyup/core/utils/formatters.dart';
import 'package:moneyup/features/budgettracker/widgets/api_widgets/forecast_dashbord.dart';
import 'package:moneyup/shared/screen/loading_screen.dart';
import 'package:moneyup/shared/widgets/app_avatar.dart';

import 'package:moneyup/features/home/screens/my_home_page.dart';
import '/features/education/screens/education.dart';
import '/features/profile/screens/profile.dart';
import '/features/transactions/screens/transactions_home.dart';

// ------------ Budget Goal Tracker Page Widget ------------ //
class PredictiveBudgetForecastor extends StatefulWidget {
  final String budgetName;
  final double goalAmount;
  final int budgetId;

  const PredictiveBudgetForecastor({
    super.key,
    required this.budgetName,
    required this.goalAmount,
    required this.budgetId,
  });

  @override
  State<PredictiveBudgetForecastor> createState() =>
      _PredictiveBudgetForecastorState();
}

class _PredictiveBudgetForecastorState
    extends State<PredictiveBudgetForecastor> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadForecator();
  }

  Future<void> _loadForecator() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading forecastor: $e');
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

  Widget _buildContent(BuildContext context, {required Key key}) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.only(top: 10, left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [AppAvatar(size: 60), SizedBox(height: 20)],
          ),
        ),
        toolbarHeight: 120,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              ),
              height: 680,
              child: Column(
                children: [
                  // Space to seperate AppBar and top edge
                  SizedBox(height: 9),

                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 25),
                          child: IconButton(
                            icon: Image.asset(
                              'assets/icons/chevronLeftArrow.png',
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 270,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 25),
                                    child: Text(
                                      widget.budgetName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text(
                                    "Predictive Forecastor",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 21,
                                      color: const Color.fromARGB(51, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: ApiColors.card,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: ApiColors.muted,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'BUDGET',
                                      style: TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: ApiColors.textSecondary,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    Text(
                                      Formatters.currency(widget.goalAmount),
                                      style: TextStyle(
                                        fontFamily: 'SF Pro',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: ApiColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  //SizedBox(height: 0),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16, right: 16, top: 4),
                      child: SingleChildScrollView(
                        child: BudgetPredictionChart(
                          userId: 'preview-user',
                          budgetId: 1 //widget.budgetId,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 255, 255, 255),
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
                    builder: (_) => MyHomePage(title: 'MoneyUp'),
                  ),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/unselectedTransactionsIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => TransactionsHome()),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/unselectedEducationIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => EducationScreen()),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/icons/unselectedSettingsIcon.png'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
