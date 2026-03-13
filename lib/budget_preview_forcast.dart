import 'package:flutter/material.dart';
import 'package:moneyup/features/budgettracker/widgets/budget_forecast.dart';
import 'package:moneyup/shared/widgets/app_avatar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:moneyup/features/home/screens/my_home_page.dart';
import '/features/education/screens/education.dart';
import '/features/profile/screens/profile.dart';
import '/features/transactions/screens/transactions_home.dart';

// ------------ Budget Goal Tracker Page Widget ------------ //
class PreviewPage extends StatefulWidget {
  final String budgetUuid;

  const PreviewPage({super.key, required this.budgetUuid});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  int? _mlBudgetId;
  String? _userId;
  bool _loading = true;
  String? _error;


  @override
  void initState() {
    super.initState();
    _loadMlBudgetId();
  }

  Future<void> _loadMlBudgetId() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('No user logged in');

      final response = await Supabase.instance.client
          .from('ml_budgets')
          .select('id')
          .eq('budget_id', widget.budgetUuid)
          .eq('user_id', userId)
          .single();

      setState(() {
        _mlBudgetId = response['id'] as int;
        _userId = userId;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
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
                  SizedBox(height: 20),

                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BudgetPredictionChart(userId: 'preview-user', budgetId: 1)
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
