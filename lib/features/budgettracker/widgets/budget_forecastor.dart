import 'package:flutter/material.dart';
import 'package:moneyup/core/constants/app_colors.dart';
import 'package:moneyup/core/utils/formatters.dart';
import 'package:moneyup/features/budgettracker/widgets/api_widgets/forecast_dashbord.dart';
import 'package:moneyup/shared/screen/loading_screen.dart';
import 'package:moneyup/shared/widgets/app_avatar.dart';

import 'package:moneyup/features/home/screens/my_home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '/features/education/screens/education.dart';
import '/features/profile/screens/profile.dart';
import '/features/transactions/screens/transactions_home.dart';

// ------------ Budget Goal Tracker Page Widget ------------ //
class PredictiveBudgetForecastor extends StatefulWidget {
  final String budgetName;
  final double goalAmount;
  final String budgetId;

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

  Widget _infoRow(String label, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label — ',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 20),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.blue),
                            const SizedBox(width: 8),
                            const Text(
                              'About Your Budget Forecast',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Text for dialog box
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reading Your Spending Chart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _infoRow(
                              'Solid line',
                              'your actual spending so far this month',
                            ),
                            _infoRow(
                              'Dotted line',
                              'where your spending is predicted to go by end of month',
                            ),
                            _infoRow('Red dashed line', 'your budget limit'),
                            _infoRow(
                              'The dot',
                              'your current spending position',
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'If the dotted line crosses the red line, you are predicted to go over budget.',
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'What is the Confidence Range?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'The confidence range shows the best- and worst-case scenarios for your spending by end of month.',
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _infoRow(
                              'Low end',
                              'if your spending slows down, you may end up here',
                            ),
                            _infoRow(
                              'High end',
                              'if your spending continues or increases, you may end up here',
                            ),
                            _infoRow(
                              'The dot',
                              'where the model predicts you\'ll most likely land',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
        title: Padding(
          padding: EdgeInsets.only(top: 10, left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [AppAvatar(size: 60), SizedBox(height: 20)],
          ),
        ),
        toolbarHeight: 130,
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
                            Flexible(
                              // 👈 Replace the SizedBox with Flexible
                              child: Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.budgetName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                        height: 1,
                                      ),
                                    ),
                                    Text(
                                      "Predictive Forecastor",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 21,
                                        color: const Color.fromARGB(
                                          51,
                                          0,
                                          0,
                                          0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                          userId: Supabase.instance.client.auth.currentUser!.id,
                          budgetId: widget.budgetId, //widget.budgetId,
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
