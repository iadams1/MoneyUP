import 'package:flutter/material.dart';

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
  FilterState _currentFilters = FilterState.empty();

  double _totalDebit = 0;
  double _totalCredit = 0;
  double _availableCredit = 0;

  TransactionType? _selectedFilter = TransactionType.debit;
  List<Transaction> _filteredTransactions = [];

  Future<void> _loadTransactions({
    TransactionType? filter,
    FilterState? filters,
  }) async {
    setState(() => _isLoading = true);

    try {
      final transactions = await _transactionService.fetchTransactions(
        filter: filter,
        filters: filters,
      );

      final totals = await _transactionService.fetchTotals();

      setState(() {
        _filteredTransactions = transactions;
        _totalDebit = totals['debit'] ?? 0;
        _totalCredit = totals['credit'] ?? 0;
        _availableCredit = totals['availableCredit'] ?? 0;
        _selectedFilter = filter;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading transactions: $e');
      setState(() => _isLoading = false);
    }
  }

  void _removeCategory(String category) async {
    final updatedCategories = {..._currentFilters.selectedCategories}
      ..remove(category);

    setState(() {
      _currentFilters = _currentFilters.copyWith(
        selectedCategories: updatedCategories
      );
    });

    await _loadTransactions(
      filter: _selectedFilter,
      filters: _currentFilters,
    );
  }

  void _removeBank(String bank) async {
    final updatedBanks = {..._currentFilters.selectedBanks}
      ..remove(bank);

    setState(() {
      _currentFilters = _currentFilters.copyWith(
        selectedBanks: updatedBanks
      );
    });

    await _loadTransactions(
      filter: _selectedFilter,
      filters: _currentFilters,
    );
  }

  void _removeDate() async {
    setState(() {
      _currentFilters = _currentFilters.copyWith(
        clearStartDate: true,
        clearEndDate: true,
      );
    });

    await _loadTransactions(
      filter: _selectedFilter,
      filters: _currentFilters,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadTransactions(filter: _selectedFilter);
  }

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
              availableCredit: _availableCredit,
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
                            final result = await showDialog<FilterState>(
                              context: context, 
                              builder: (_) => FilterDialog(
                                initialState: _currentFilters,
                                selectedType: _selectedFilter!,
                                ),
                            );
                            if (result != null) {
                              setState(() {_currentFilters = result;});
                              await _loadTransactions(
                                filter: _selectedFilter,
                                filters: _currentFilters,
                              );
                            }
                          },
                          icon: Icon(Icons.filter_alt_outlined),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  ActiveFilterChips(
                    filters: _currentFilters,
                    onRemoveCategory: _removeCategory,
                    onRemoveBank: _removeBank,
                    onRemoveDate: _removeDate,
                    onClearAll: () async {
                      setState(() {
                        _currentFilters = FilterState.empty();
                      });
                      await _loadTransactions(filter: _selectedFilter);
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