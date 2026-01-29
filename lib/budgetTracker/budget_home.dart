import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'budget_creation.dart';
import 'budget_goaltracker.dart';

import 'package:moneyup/main.dart';
import 'package:moneyup/transactions/transactions_home.dart';
import 'package:moneyup/education/education.dart';
import 'package:moneyup/profile.dart';

// ---------------- Budget Goal Page Widget ---------------- //
enum TimeFilter { thisWeek, lastWeek, thisMonth, lastMonth, thisYear }

class BudgetGoalPage extends StatefulWidget {
  const BudgetGoalPage({super.key});
  @override
  State<BudgetGoalPage> createState() => _BudgetGoalPageState();
}

class _BudgetGoalPageState extends State<BudgetGoalPage> {
  late Future<List<dynamic>> _future;
  late Map<int, double> spendingData = {};
  late Map<int, String> categoryTitles = {};

  TimeFilter selectedFilter = TimeFilter.thisWeek;

  static const Map<TimeFilter, String> filterLabels = {
    TimeFilter.thisWeek: "This Week",
    TimeFilter.lastWeek: "Last Week",
    TimeFilter.thisMonth: "This Month",
    TimeFilter.lastMonth: "Last Month",
    TimeFilter.thisYear: "This Year",
  };

  Future<List<dynamic>> getUserBudgets() async {
    final budgetsResponse = await Supabase.instance.client
        .from('budgets')
        .select('*')
        .eq('user_ID', 1001);

    final categoriesResponse = await Supabase.instance.client
        .from('category_table')
        .select('category_ID, Title');

    final budgets = budgetsResponse as List<dynamic>;
    final categories = categoriesResponse as List<dynamic>;

    final budgetsWithId = budgets.map((budget) {
      final matchingCategory = categories.firstWhere(
        (c) => c['Title'] == budget['Category'],
        orElse: () => {'category_ID': 0},
      );

      final categoryID = (matchingCategory['category_ID'] ?? 0) as int;

      return {...budget, 'category_ID': categoryID};
    }).toList();
    
    return budgetsWithId;
  }

  Future<void> deleteBudget(String budgetId) async {
  try {
    await Supabase.instance.client
        .from('budgets')
        .delete()
        .eq('budget_ID', budgetId)
        .eq('user_ID', 1001);

    debugPrint('Deletion was successful!');

  } catch (error) {
    debugPrint('Error Deleting rows: $error');
    rethrow;
  }
}

  Future<void> confirmDelete(BuildContext context, String budgetID) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Delete Budget",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            "Are you sure you want to delete this budget?",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(context, false),
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
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(
                            255,
                            0,
                            0,
                            0,
                          ),
                    ),
                    child: const Text(
                      'Delete',
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

    if (shouldDelete == true) {
      deleteBudget(budgetID);
      setState(() {
      _future = getUserBudgets();
    });
    }
  }

  Future<void> loadSpendingData() async {
    final supabase = Supabase.instance.client;

    // Determine timeframe
    DateTime now = DateTime.now();
    late DateTime start;
    late DateTime end;

    switch (selectedFilter) {
      case TimeFilter.thisWeek:
        start = now.subtract(Duration(days: now.weekday - 1));
        end = DateTime(now.year, now.month, now.day + 1);
        break;

      case TimeFilter.lastWeek:
        final lastWeekEnd = now.subtract(Duration(days: now.weekday));
        start = lastWeekEnd.subtract(Duration(days: 6));
        end = DateTime(
          lastWeekEnd.year,
          lastWeekEnd.month,
          lastWeekEnd.day + 1,
        );
        break;

      case TimeFilter.thisMonth:
        start = DateTime(now.year, now.month, 1);
        end = now.add(Duration(days: 1));
        break;

      case TimeFilter.lastMonth:
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 1);
        break;

      case TimeFilter.thisYear:
        start = DateTime(now.year, 1, 1);
        end = now.add(Duration(days: 1));
        break;
    }

    final response = await supabase
        .from('budget_transactions')
        .select(
          'category_table!inner(category_ID, Title), spendingAmount, transactionDate',
        )
        .eq('user_ID', 1001)
        .gte('transactionDate', start.toIso8601String().split("T")[0])
        .lt('transactionDate', end.toIso8601String().split("T")[0]);

    final Map<int, double> tempData = {};
    final Map<int, String> titlesById = {};

    for (final row in response) {
      final categoryId = row['category_table']['category_ID'] as int;
      final categoryTitle = row['category_table']['Title'] as String;
      final amount = (row['spendingAmount'].toDouble() ?? 0.0);

      tempData.update(
        categoryId,
        (value) => value + amount,
        ifAbsent: () => amount,
      );
      titlesById[categoryId] = categoryTitle;
    }

    setState(() {
      spendingData = tempData;
      categoryTitles = titlesById;
    });
  }

  @override
  void initState() {
    super.initState();
    loadSpendingData();
    _future = getUserBudgets();
  }

  @override
  Widget build(BuildContext context) {
    Color getCategoryColor(int categoryID) {
      switch (categoryID) {
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

    return Scaffold(
      backgroundColor: Colors.white,
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
                  color: const Color.fromARGB(0, 255, 255, 255),
                  border: Border.all(
                    width: 3,
                    color: const Color.fromARGB(255, 121, 121, 121),
                  ),
                ),
                child: Image.asset('assets/icons/profileIcon.png'),
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
        toolbarHeight: 120,
      ),

      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final budgets = snapshot.data!;
          if (budgets.isEmpty) {
            debugPrint('Budget data: $budgets');
            return const Center(child: Text('No budgets found.'));
          }

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/background.png',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 35),

                      // ---------- Spending Overview Section ----------- //
                      Padding(
                        padding: const EdgeInsets.fromLTRB(35, 0, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Spending Overview",
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(height: 10),

                            Row(
                              spacing: 5,
                              children: [
                                Column(
                                  children: [
                                    // Time Filter
                                    Container(
                                      height: 40,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                              20,
                                              0,
                                              0,
                                              0,
                                            ),
                                            spreadRadius: 0,
                                            blurRadius: 12,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: DropdownMenu<TimeFilter>(
                                        width: 162.7,
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        initialSelection: selectedFilter,
                                        inputDecorationTheme:
                                            InputDecorationTheme(
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              filled: false,
                                              contentPadding: EdgeInsets.all(
                                                15,
                                              ),
                                              constraints: BoxConstraints.tight(
                                                const Size.fromHeight(40),
                                              ),
                                            ),
                                        onSelected: (value) {
                                          if (value != null) {
                                            setState(() {
                                              selectedFilter = value;
                                            });
                                            loadSpendingData();
                                          }
                                        },
                                        dropdownMenuEntries: TimeFilter.values
                                            .map((filter) {
                                              return DropdownMenuEntry(
                                                value: filter,
                                                label: filterLabels[filter]!,
                                              );
                                            })
                                            .toList(),
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    // Legend
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: spendingData.keys.map((
                                        categoryId,
                                      ) {
                                        final categoryTitle =
                                            categoryTitles[categoryId] ??
                                            "Unknown";
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          child: Row(
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                margin: const EdgeInsets.only(
                                                  top: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: getCategoryColor(
                                                    categoryId,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              SizedBox(
                                                width: 140,
                                                child: Text(
                                                  categoryTitle,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),

                                // Pie chart
                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: spendingData.isEmpty
                                      ? const Center(
                                          child: Text(
                                            "📊 No spending data currently.",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : PieChart(
                                          PieChartData(
                                            sectionsSpace: 0,
                                            centerSpaceRadius: 20,
                                            sections: spendingData.entries.map((
                                              e,
                                            ) {
                                              return PieChartSectionData(
                                                value: e.value,
                                                color: getCategoryColor(e.key),
                                                radius: 75,
                                                titleStyle: const TextStyle(
                                                  color: Colors.transparent,
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(35, 0, 0, 10),
                        child: Row(
                          spacing: 110,
                          children: [
                            // ------------- Budget Goals Section ------------- //
                            Text(
                              "Budget Goals",
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 30,
                                icon: Image.asset(
                                  'assets/icons/plusCircle.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                ),
                                onPressed: () async {
                                  final result = await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BudgetCreationPage(),
                                    ),
                                  );

                                  if (result == true) {
                                    setState(() {
                                      _future = getUserBudgets();
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: ListView.builder(
                          itemCount: budgets.length,
                          itemBuilder: ((context, index) {
                            final budget = budgets[index];

                            final String title = budget['Title'];
                            final double saved = (budget['AmountSaved'] ?? 0)
                                .toDouble();
                            final double needed = (budget['AmountNeeded'] ?? 0)
                                .toDouble();
                            final double percent =
                                (saved / (budget['Goal'] ?? 0).toDouble())
                                    .clamp(0, 1);

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 0,
                              ),
                              child: Slidable(
                                key: ValueKey(budget),

                                startActionPane: ActionPane(
                                  motion: const BehindMotion(),
                                  extentRatio: 0.20,
                                  dragDismissible: false,
                                  children: [
                                    SlidableAction(
                                      flex: 1,
                                      onPressed: (_) {
                                        confirmDelete(context, budget["budget_ID"] as String);
                                      },
                                      icon: Icons.delete,
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        // Progress Bar
                                        SizedBox(
                                          height: 90,
                                          width: 90,
                                          child: CircularPercentIndicator(
                                            radius: 28,
                                            lineWidth: 9,
                                            percent: percent,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                  6,
                                                  227,
                                                  50,
                                                  50,
                                                ),
                                            progressColor: getCategoryColor(
                                              budget['category_ID'],
                                            ),
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                          ),
                                        ),

                                        const SizedBox(width: 0),

                                        // Title & Budget Amounts'
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                style: const TextStyle(
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),

                                              Text(
                                                "\$${saved.toStringAsFixed(2)} Saved",
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                "\$${needed.toStringAsFixed(2)} Needed",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color.fromARGB(
                                                    107,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        IconButton(
                                          icon: Image.asset(
                                            'assets/icons/chevronRightArrow.png',
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder: (_) => BudgetPage(
                                                  budgetId: budget['budget_ID'],
                                                  categoryId:
                                                      budget['category_ID'],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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