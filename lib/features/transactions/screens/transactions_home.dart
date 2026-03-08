import 'package:flutter/material.dart';
import 'package:moneyup/shared/screen/loading_screen.dart';

import '../widgets/filters/active_filter_chips.dart';
import '/features/transactions/widgets/filter_dialog.dart';
import '/features/transactions/widgets/total_amount.dart';
import '/features/transactions/widgets/no_transaction_view.dart';
import '/features/transactions/widgets/transaction_card.dart';
import '/services/transaction_service.dart';
import '/shared/widgets/bottom_nav.dart';
import '/shared/widgets/profile_menu_card.dart';
import '/models/transaction.dart';
import '/models/filter_state.dart';

class TransactionsHome extends StatefulWidget {
  const TransactionsHome({super.key});

  @override
  State<TransactionsHome> createState() => _TransactionsHomeState();
}
  
class _TransactionsHomeState extends State<TransactionsHome> {
  bool _isLoading = true;
  final TransactionService _transactionService = TransactionService();
  FilterState _currentFilters = FilterState();

  double _totalDebit = 0;
  double _totalCredit = 0;
  TransactionType? _selectedFilter = TransactionType.debit;
  List<Transaction> _filteredTransactions = [];

  Future<void> _loadTransactions({TransactionType? filter}) async {
    setState(() => _isLoading = true);

    try {
      final transactions = await _transactionService.fetchTransactions(
        filter: filter,
        filters: _currentFilters
      );

      final type = filter == TransactionType.credit ? 'credit' : 'depository';

      final totals = await _transactionService.fetchTotals(
        bankName: _currentFilters.selectedBanks.isEmpty
            ? null
            : _currentFilters.selectedBanks.toList(),
        type: type,
      );

      setState(() {
        _filteredTransactions = transactions;
        _totalDebit = totals['debit'] ?? 0;
        _totalCredit = totals['credit'] ?? 0;
        _selectedFilter = filter;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading transactions: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions(filter: _selectedFilter);
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
                  _loadTransactions(filter: TransactionType.debit);
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: _selectedFilter == TransactionType.debit
                    ? Colors.white : Colors.transparent,
                  foregroundColor: _selectedFilter == TransactionType.debit
                    ? Colors.black : Colors.white,
                ),
                child: Text(
                  'View Debit',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                   _loadTransactions(filter: TransactionType.credit);
                },
                style: TextButton.styleFrom(
                  backgroundColor: _selectedFilter == TransactionType.credit
                    ? Colors.white : Colors.transparent,
                  foregroundColor: _selectedFilter == TransactionType.credit
                    ? Colors.black : Colors.white,
                ),
                child: Text(
                  'View Credit',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
              IconButton( // INFO ICON BUTTON
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
          Positioned(
            top: 165,
            left: 25,
            right: 25,
            child: TotalAmountView(
              selectedFilter: _selectedFilter!, 
              totalDebit: _totalDebit, 
              totalCredit: _totalCredit,
            ),
          ),
          SafeArea( // WHITE BOX CONTAINER
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 120),
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
                          onPressed: () async {
                            final result = await showDialog(
                              context: context, 
                              builder: (_) => FilterDialog(
                                initialState: _currentFilters,
                                selectedType: _selectedFilter!,
                                ),
                            );
                            if (result != null) {
                              setState(() {_currentFilters = result;});
                              _loadTransactions(filter: _selectedFilter);
                            }
                          },
                          icon: Icon(Icons.filter_alt_outlined, size: 30,),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 0),
                  ActiveFilterChips(
                    filters: _currentFilters,
                    onRemoveBank: (bank) {
                      setState(() {
                        _currentFilters.selectedBanks.remove(bank);
                      });
                      _loadTransactions(filter: _selectedFilter);
                    },
                    onRemoveCategory: (category) {
                      setState(() {
                        _currentFilters.selectedBanks.remove(category);
                      });
                      _loadTransactions(filter: _selectedFilter);
                    },
                    onRemoveStartDate: () {
                      setState(() {
                        _currentFilters = FilterState(
                          selectedBanks: _currentFilters.selectedBanks,
                          selectedCategories: _currentFilters.selectedCategories,
                          endDate: _currentFilters.endDate,
                        );
                      });
                      _loadTransactions(filter: _selectedFilter);
                    },
                    onRemoveEndDate: () {
                      setState(() {
                        _currentFilters = FilterState(
                          selectedBanks: _currentFilters.selectedBanks,
                          selectedCategories: _currentFilters.selectedCategories,
                          startDate: _currentFilters.startDate,
                        );
                      });
                      _loadTransactions(filter: _selectedFilter);
                    },
                    onClearAll: () {
                      setState(() {
                        _currentFilters = FilterState();
                      });
                      _loadTransactions(filter: _selectedFilter);
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: _filteredTransactions.isEmpty
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