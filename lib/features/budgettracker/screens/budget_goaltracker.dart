import 'package:flutter/material.dart';
import 'package:moneyup/features/education/screens/education.dart';
import 'package:moneyup/features/proflie/screens/profile.dart';
import 'package:moneyup/features/transactions/screens/transactions_home.dart';
import 'package:moneyup/main.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'budget_home.dart';

// ------------ Budget Goal Tracker Page Widget ------------ //
class BudgetPage extends StatefulWidget {
  final String budgetId;
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
  late Future<List<dynamic>> _future;
  bool _initializedArrow = false;
  double previousSaved = 0;

  ValueNotifier<double> overallGoalAmount = ValueNotifier<double>(
    0,
  ); // Overall budget goal
  ValueNotifier<double> goalSaved = ValueNotifier<double>(
    0,
  ); // Amount saved towards the goal
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

  Future<List<dynamic>> getBudget(String budgetId) async {
    final response = await Supabase.instance.client
        .from('budgets')
        .select('*')
        .eq('budget_ID', budgetId)
        .eq('user_ID', 1001);

    return response;
  }

  @override
  void initState() {
    super.initState();
    _future = getBudget(widget.budgetId);
  }

  Future<void> updateBudget() async {
    final supabase = Supabase.instance.client;

    try {
      await supabase
          .from('budgets')
          .update({
            'AmountSaved': goalSaved.value,
            'AmountNeeded': goalNeeded.value,
          })
          .eq('budget_ID', widget.budgetId)
          .select();
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
                      Navigator.pop(context);
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

  Color getColor(int categoryId) {
    switch (categoryId) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.green;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgetColor = getColor(widget.categoryId);

    return Scaffold(
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

          FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final budgets = snapshot.data!;
              if (budgets.isEmpty) {
                return const Center(child: Text('No budgets found.'));
              }

              return ListView.builder(
                itemCount: budgets.length,
                itemBuilder: ((context, index) {
                  final budget = budgets[index];

                  final savedAmount = (budget['AmountSaved'] ?? 0).toDouble();
                  final goalAmount = (budget['Goal'] ?? 0).toDouble();
                  final neededAmount = (budget['AmountNeeded'] ?? 0).toDouble();

                  // initialize the calculator with database values
                  if (!_initializedArrow) {
                    initBudget(savedAmount, goalAmount, neededAmount);
                    _initializedArrow = true;
                  }

                  return SafeArea(
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (context) =>
                                              const BudgetGoalPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(left: 25),
                                  child: Text(
                                    budget['Title'],
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
                                            "${((goalSaved.value / overallGoalAmount.value) * 100).clamp(0.0, 100.0).toStringAsFixed(0)}%",
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
                            builder: (context, overallGoalAmount, _) {
                              return Text(
                                "Budget Goal \$${budget['Goal'].toStringAsFixed(2)}",
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
                            builder: (context, goalSaved, _) {
                              return Text(
                                "\$${goalSaved.toStringAsFixed(2)} Saved",
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
                            builder: (context, goalNeeded, _) {
                              return Text(
                                "\$${goalNeeded.toStringAsFixed(2)} Needed",
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
                  );
                }),
              );
            },
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
