import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '/features/budgettracker/utils/category_colors.dart';
import '/features/education/screens/education.dart';
import '/features/profile/screens/profile.dart';
import '/features/transactions/screens/transactions_home.dart';
import '/main.dart';
import '/models/budget.dart';
import '/services/service_locator.dart';
import '/shared/screen/loading_screen.dart';

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

  ValueNotifier<double> overallGoalAmount = ValueNotifier<double>(0,); // Overall budget goal
  ValueNotifier<double> goalSaved = ValueNotifier<double>(0,); // Amount saved towards the goal
  ValueNotifier<double> goalNeeded = ValueNotifier<double>(0);

  initBudget(double saved, double goal, double needed) {
    goalSaved.value = saved;
    overallGoalAmount.value = goal;
    goalNeeded.value = needed;
    previousSaved = saved;
  }

  // Calculates the updated amounts based on user input
  calculateBudget(double userAmount, bool isAddition) {
    previousSaved = goalSaved.value;

    if (isAddition) {
      goalSaved.value += userAmount;
    } else {
      if (goalSaved.value == 0) {
        userAmount = 0;
      }
      if (goalSaved.value - userAmount < 0) return;
      goalSaved.value -= userAmount;
    }

    goalNeeded.value = overallGoalAmount.value - goalSaved.value;

    if (goalNeeded.value < 0) {
      goalNeeded.value = 0;
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
        amountSaved: goalSaved.value,
        amountNeeded: goalNeeded.value,
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

                        previousSaved = goalSaved.value;
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
        initBudget(budget.amountSaved, budget.goal, budget.amountNeeded);
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
    goalSaved.dispose();
    goalNeeded.dispose();
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
            children: [
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromARGB(0, 0, 0, 0),
                  border: Border.all(
                    width: 3,
                    color: const Color.fromARGB(255, 121, 121, 121),
                  ),
                ),
                child: Image.asset('assets/icons/profileIcon.png'),
              ),

              SizedBox(height: 20),
            ],
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
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50),
                ),
              ),
              height: 680,
              child: Column(
                children: [
                  // Space to seperate AppBar and top edge
                  SizedBox(height: 20),

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
                              Navigator.pop(context, _didUpdate);
                            },
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(left: 25),
                          child: Text(
                            budget!.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 33,
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
                  ),

                  SizedBox(height: 10),

                  ValueListenableBuilder(
                    valueListenable: goalSaved,
                    builder: (context, currentSaved, _) {
                      IconData arrowIcon;
                      Color arrowColor;

                      if (currentSaved > previousSaved) {
                        arrowIcon = Icons.arrow_upward;
                        arrowColor = Colors.green;
                      } else if (currentSaved < previousSaved) {
                        arrowIcon = Icons.arrow_downward;
                        arrowColor = Colors.red;
                      } else {
                        arrowIcon = Icons.remove; // no change
                        arrowColor = const Color.fromARGB(6, 0, 0, 0);
                      }

                      final pct = budget.percentComplete;
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
                                  (goalSaved.value /
                                          overallGoalAmount.value)
                                      .clamp(0.0, 1.0),
                              center: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    arrowIcon,
                                    color: arrowColor,
                                    size: 40,
                                  ),
                                  Text(
                                    "$pctText%",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 40,
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: const Color.fromARGB(
                                6,
                                0,
                                0,
                                0,
                              ),
                              progressColor: budgetColor,
                              circularStrokeCap:
                                  CircularStrokeCap.round,
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
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  ValueListenableBuilder<double>(
                    valueListenable: goalSaved,
                    builder: (context, saved, _) {
                      return Text(
                        "\$${saved.toStringAsFixed(2)} Saved",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 2),

                  ValueListenableBuilder<double>(
                    valueListenable: goalNeeded,
                    builder: (context, needed, _) {
                      return Text(
                        "\$${needed.toStringAsFixed(2)} Needed",
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
                        icon: Image.asset(
                          'assets/icons/plusCircle.png',
                        ),
                        onPressed: () {
                          _showAmountDialog(isAddition: true);
                        },
                      ),
                      SizedBox(width: 50),
                      IconButton(
                        icon: Image.asset(
                          'assets/icons/minusCircle.png',
                        ),
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
