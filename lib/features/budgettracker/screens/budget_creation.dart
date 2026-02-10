import 'package:flutter/material.dart';
import 'package:moneyup/features/education/screens/education.dart';
import 'package:moneyup/features/proflie/screens/profile.dart';
import 'package:moneyup/features/transactions/screens/transactions_home.dart';
import 'package:moneyup/models/budget_type.dart';
import 'package:moneyup/main.dart';
import 'package:moneyup/services/service_locator.dart';

// -------------- Budget Creation Page Widget -------------- //
class BudgetCreationPage extends StatefulWidget {
  const BudgetCreationPage({super.key});
  @override
  State<BudgetCreationPage> createState() => _BudgetCreationState();
}

class _BudgetCreationState extends State<BudgetCreationPage> {
  BudgetType? selectedType;

  TextEditingController budgetTitle = TextEditingController();
  TextEditingController budgetGoal = TextEditingController();
  TextEditingController budgetSaved = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.transparent,
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

      // Background Gradient
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 45),

                  // Title and TextBoxes
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 45),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create a Budget Goal",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          "Title",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(
                          width: 340,
                          child: TextField(
                            controller: budgetTitle,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(121, 121, 121, 0.357),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(0),
                              ),
                              suffixIcon: IconButton(
                                icon: Image.asset('assets/icons/X.png'),
                                onPressed: () {
                                  budgetTitle.clear();
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Text(
                          "Spending Category",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(
                          width: 340,
                          child: DropdownMenu<BudgetType>(
                            hintText: "Select a Spending Category.",
                            width: 340,
                            textStyle: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                            initialSelection: selectedType,
                            dropdownMenuEntries: BudgetType.values.map((type) {
                              return DropdownMenuEntry(
                                value: type,
                                label: type.label, // use the custom string
                              );
                            }).toList(),
                            onSelected: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedType = value;
                                });
                              }
                            },
                            inputDecorationTheme: InputDecorationTheme(
                              filled: true,
                              fillColor: Color.fromRGBO(121, 121, 121, 0.357),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Text(
                          "Goal Amount",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(
                          width: 340,
                          child: TextField(
                            controller: budgetGoal,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(121, 121, 121, 0.357),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(0),
                              ),
                              suffixIcon: IconButton(
                                icon: Image.asset('assets/icons/X.png'),
                                onPressed: () {
                                  budgetGoal.clear();
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        Text(
                          "Amount already saved",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(
                          width: 340,
                          child: TextField(
                            controller: budgetSaved,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color.fromRGBO(121, 121, 121, 0.357),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(0),
                              ),
                              suffixIcon: IconButton(
                                icon: Image.asset('assets/icons/X.png'),
                                onPressed: () {
                                  budgetSaved.clear();
                                },
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 30, right: 40),
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 50,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 43, 34, 111),
                                        Color.fromARGB(255, 26, 78, 129),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (budgetGoal.text.isNotEmpty &&
                                          budgetSaved.text.isNotEmpty &&
                                          budgetTitle.text.isNotEmpty) {
                                        final title = budgetTitle.text.trim();
                                        final goal =
                                            double.tryParse(
                                              budgetGoal.text.trim(),
                                            ) ??
                                            0.0;
                                        final saved =
                                            double.tryParse(
                                              budgetSaved.text.trim(),
                                            ) ??
                                            0.0;

                                        await budgetService.insertBudget(
                                          title,
                                          goal,
                                          saved,
                                          selectedType!,
                                        );
                                      }
                                      Navigator.pop(context, true);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 55,
                                      ),
                                    ),
                                    child: const Text(
                                      'Add',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
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