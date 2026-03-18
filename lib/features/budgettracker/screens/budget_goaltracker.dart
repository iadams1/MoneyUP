import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/features/home/screens/my_home_page.dart';
import '/features/budgettracker/widgets/budget_forecastor.dart';
import '/features/budgettracker/utils/category_colors.dart';
import '/features/education/screens/education.dart';
import '/features/profile/screens/profile.dart';
import '/features/transactions/screens/transactions_home.dart';
import '/models/budget.dart';
import '/services/service_locator.dart';
import '/shared/screen/loading_screen.dart';
import '/shared/widgets/app_avatar.dart';

// ------------ Budget Goal Tracker Page Widget ------------ //
class BudgetPage extends StatefulWidget {
  final dynamic budgetId;
  final int categoryId;

  const BudgetPage({
    super.key,
    required this.budgetId,
    required this.categoryId,
  });

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  bool _initializedArrow = false;
  bool _didUpdate = false;
  bool _isLoading = true;

  Budget? _budget;

  double previousSaved = 0;

  ValueNotifier<double> overallGoalAmount = ValueNotifier<double>(
    0,
  ); // Overall budget goal
  ValueNotifier<double> goalSpent = ValueNotifier<double>(
    0,
  ); // Amount saved towards the goal
  ValueNotifier<double> goalRemain = ValueNotifier<double>(0);

  void initBudget(double saved, double goal, double needed) {
    goalSpent.value = saved;
    overallGoalAmount.value = goal;
    goalRemain.value = needed;
    previousSaved = saved;
  }

  // Calculates the updated amounts based on user input
  void calculateBudget(double userAmount, bool isAddition) {
    previousSaved = goalSpent.value;

    if (isAddition) {
      goalSpent.value += userAmount;
    } else {
      if (goalSpent.value == 0) {
        userAmount = 0;
      }
      if (goalSpent.value - userAmount < 0) return;
      goalSpent.value -= userAmount;
    }

    goalRemain.value = overallGoalAmount.value - goalSpent.value;

    if (goalRemain.value < 0) {
      goalRemain.value = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBudgetTracker();
  }

  Future<void> updateBudget() async {
    try {
      await budgetService.updateBudget(
        budgetId: widget.budgetId,
        amountSpent: goalSpent.value,
        amountRemaining: goalRemain.value,
      );

      _didUpdate = true;
    } catch (e) {
      debugPrint('Error updating budget: $e');
    }
  }

  Future<void> _showAmountDialog({required bool isAddition}) async {
    final TextEditingController amountController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Please enter an amount."),
          backgroundColor: Colors.white,
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: isAddition ? '+ \$0000.00' : '- \$0000.00',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () async {
                      final enteredAmount = amountController.text.trim();
                      if (enteredAmount.isNotEmpty) {
                        final double amount =
                            double.tryParse(enteredAmount) ?? 0.0;

                        previousSaved = goalSpent.value;
                        calculateBudget(amount, isAddition);
                        await updateBudget();
                      }
                      Navigator.pop(context, _didUpdate);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadBudgetTracker() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final budget = await budgetService.getSpecificBudget(widget.budgetId);
      if (!mounted) return;

      if (budget == null) {
        setState(() {
          _budget = null;
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _budget = budget;
        _isLoading = false;
      });

      if (!_initializedArrow) {
        initBudget(budget.amountSpent, budget.goal, budget.amountRemaining);
        _initializedArrow = true;
      }
    } catch (e) {
      debugPrint('Error loading budget: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    overallGoalAmount.dispose();
    goalSpent.dispose();
    goalRemain.dispose();
    super.dispose();
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
    final budgetColor = getCategoryColor(widget.categoryId);

    final budget = _budget;

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 25),
                              child: IconButton(
                                icon: Image.asset(
                                  'assets/icons/chevronLeftArrow.png',
                                ),
                                onPressed: () {
                                  Navigator.pop(context, _didUpdate);
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PredictiveBudgetForecastor(
                                            budgetId: 1,
                                            budgetName: budget!.title,
                                            goalAmount: budget.goal,
                                          ),
                                    ),
                                  );
                                },
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromRGBO(25, 50, 100, 1),
                                        Color.fromRGBO(47, 52, 126, 1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(200),
                                  ),
                                  child: SizedBox(
                                    width: 155,
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        "View Forecastor",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 360,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 25),
                                    child: Text(
                                      budget!.title,
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
                                    "Budget Goal",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 23,
                                      color: const Color.fromARGB(51, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  ValueListenableBuilder(
                    valueListenable: goalSpent,
                    builder: (context, currentSaved, _) {
                      IconData arrowIcon;
                      Color arrowColor;

                      if (currentSaved > previousSaved) {
                        arrowIcon = Icons.arrow_upward;
                        arrowColor = Colors.red;
                      } else if (currentSaved < previousSaved) {
                        arrowIcon = Icons.arrow_downward;
                        arrowColor = Colors.green;
                      } else {
                        arrowIcon = Icons.remove; // no change
                        arrowColor = const Color.fromARGB(6, 0, 0, 0);
                      }

                      final pct = overallGoalAmount.value == 0
                          ? 0.0
                          : (currentSaved / overallGoalAmount.value).clamp(
                              0.0,
                              1.0,
                            );
                      final pctText = (pct * 100).toStringAsFixed(0);

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 240,
                            height: 240,
                            child: CircularPercentIndicator(
                              radius: 120,
                              lineWidth: 38,
                              percent:
                                  (goalSpent.value / overallGoalAmount.value)
                                      .clamp(0.0, 1.0),
                              center: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(arrowIcon, color: arrowColor, size: 40),
                                  Text(
                                    "$pctText%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 40,
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: const Color.fromARGB(6, 0, 0, 0),
                              progressColor: budgetColor,
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  ValueListenableBuilder<double>(
                    valueListenable: overallGoalAmount,
                    builder: (context, overall, _) {
                      return Text(
                        "Budget Goal \$${overall.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  ValueListenableBuilder<double>(
                    valueListenable: goalSpent,
                    builder: (context, spent, _) {
                      return Text(
                        "\$${spent.toStringAsFixed(2)} Spent",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 2),

                  ValueListenableBuilder<double>(
                    valueListenable: goalRemain,
                    builder: (context, remain, _) {
                      return Text(
                        "\$${remain.toStringAsFixed(2)} Remaining",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 19,
                          color: const Color.fromARGB(87, 8, 8, 8),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset('assets/icons/plusCircle.png'),
                        onPressed: () {
                          _showAmountDialog(isAddition: true);
                        },
                      ),
                      SizedBox(width: 50),
                      IconButton(
                        icon: Image.asset('assets/icons/minusCircle.png'),
                        onPressed: () {
                          _showAmountDialog(isAddition: false);
                        },
                      ),
                    ],
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
