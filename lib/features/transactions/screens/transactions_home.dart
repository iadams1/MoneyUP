import 'package:flutter/material.dart';

import '/features/transactions/widgets/no_transaction_view.dart';
import '/features/transactions/widgets/transaction_card.dart';
import '/shared/widgets/bottom_nav.dart';
import '/shared/widgets/profile_menu_card.dart';
import '/models/transaction.dart';

class TransactionsHome extends StatefulWidget {
  const TransactionsHome({super.key});

  @override
  State<TransactionsHome> createState() => _TransactionsHomeState();
}
  
class _TransactionsHomeState extends State<TransactionsHome> {
  // bool _isLoading = false;
  // TransactionType? _selectedFilter;
  
  List<Transaction> _filteredTransactions = [];
  final List<Transaction> _allTransactions = [
    Transaction(
      title: 'Starbucks', 
      category: 'Food & Drink', 
      amount: 7.50, 
      authorizedDate: DateTime.now(), 
      // type: TransactionType.debit
    ),  
    Transaction(
      title: 'American Airlines', 
      category: 'Travel', 
      amount: 180, 
      authorizedDate: DateTime.now(), 
      // type: TransactionType.credit
    ), 
    Transaction(
      title: 'Royal Farms', 
      category: 'Transportation', 
      amount: 24.25, 
      authorizedDate: DateTime.now(), 
      // type: TransactionType.credit
    ), 
    Transaction(
      title: 'Topgolf', 
      category: 'Entertainment', 
      amount: 8, 
      authorizedDate: DateTime.now(), 
      // type: TransactionType.debit
    ),
    Transaction(
      title: 'Planet Fitness', 
      category: 'Personal Care', 
      amount: 10, 
      authorizedDate: DateTime.now(), 
      // type: TransactionType.debit
    ), 
    Transaction(
      title: 'Walmart', 
      category: 'General Merchandise', 
      amount: 20.18,
      authorizedDate: DateTime.now(), 
      // type: TransactionType.debit
    ), 
  ];

  @override
  void initState() {
    super.initState();
    _filteredTransactions = _allTransactions;
  }

  // void _applyFilter() {
  //   setState(() {
  //     if (_selectedFilter == null) {
  //       _filteredTransactions = _allTransactions;
  //     }
  //     else {
  //       _filteredTransactions = _allTransactions
  //           .where((t) => t.type == _selectedFilter)
  //           .toList();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ProfileMenuCard(),
              TextButton(
                onPressed: () {
                  // setState(() {
                  //   _selectedFilter = TransactionType.debit;
                  //   _applyFilter();
                  // });
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  'View Debit',
                ),
              ),
              TextButton(
                onPressed: () {
                  // setState(() {
                  //   _selectedFilter = TransactionType.credit;
                  //   _applyFilter();
                  // });
                },
                child: Text(
                  'View Credit',
                  style: TextStyle(color: Colors.white)
                ),
              ),
              IconButton(
                onPressed: () {
                  //
                },
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              IconButton(
                onPressed: () {
                  // print('Notification icon pressed');
                }, 
                icon: Icon(
                  Icons.notifications_outlined, 
                  color: Colors.white,
                  size: 25,
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
            child: Image.asset( // BACKGROUND
              'assets/images/mu_bg.png',
              fit: BoxFit.fill
            ),
          ),
          SafeArea( // WHITE BOX CONTAINER
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Latest Transactions',
                          style: TextStyle(
                            fontFamily: 'SF Pro',
                            fontWeight: FontWeight.w600,
                            fontSize: 28
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            //
                          },
                          icon: Icon(Icons.filter_alt_outlined),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: _allTransactions.isEmpty
                      ? NoTransactionView()
                      : ListView.builder(
                        itemCount: _filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final t = _filteredTransactions[index];
                        
                          return Padding(
                            padding: const EdgeInsets.only(bottom:15),
                            child: TransactionCard(transaction: t,),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}