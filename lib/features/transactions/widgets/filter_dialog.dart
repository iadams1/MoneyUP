import 'package:flutter/material.dart';

import 'filters/bank_filter_section.dart';
import 'filters/category_filter_section.dart';
import 'filters/date_filter_section.dart';
import '/services/transaction_service.dart';
import '/models/transaction.dart';
import '/models/filter_state.dart';

class FilterDialog extends StatefulWidget {
  final FilterState initialState;
  final TransactionType selectedType;

  const FilterDialog ({
    super.key,
    required this.initialState,
    required this.selectedType,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  bool _isLoading = true;
  final TransactionService _service = TransactionService();

  List<String> bankAccounts = [];
  List<String> categories = [];
  late Set<String> selectedBanks;
  late Set<String> selectedCategories;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();

  selectedBanks = {...widget.initialState.selectedBanks};
  selectedCategories = {...widget.initialState.selectedCategories};
  startDate = widget.initialState.startDate;
  endDate = widget.initialState.endDate;

    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final filterData = await _service.fetchFilters(widget.selectedType);

    setState(() {
      bankAccounts = filterData.institutions;
      categories = filterData.categories;
      _isLoading = false;
    });
  }

  void toggleSelection(Set<String> set, String value) {
    setState(() {
      set.contains(value) ? set.remove(value) : set.add(value);
    });
  }

  void clearBanks() => setState(() => selectedBanks.clear());
  void clearCategories() => setState(() => selectedCategories.clear());
  void clearDates() => setState(() {
      startDate = null;
      endDate = null;
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: _isLoading 
      ? const Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        )
      : Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FILTER PANEL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 10,),
              BankFilterSection(
                banks: bankAccounts,
                selectedBanks: selectedBanks,
                onToggle: (bank) {
                  setState(() {
                    selectedBanks.contains(bank)
                      ? selectedBanks.remove(bank)
                      : selectedBanks.add(bank);
                  });
                },
                onClear: () => setState(() => selectedBanks.clear()),
              ),
              const SizedBox(height: 20),
              CategoryFilterSection(
                categories: categories,
                selectedCategories: selectedCategories,
                onToggle: (category) {
                  setState(() {
                    selectedCategories.contains(category)
                      ? selectedCategories.remove(category)
                      : selectedCategories.add(category);
                  });
                },
                onClear: () => setState(() => selectedCategories.clear()),
              ),
              const SizedBox(height: 20,),
              DateFilterSection(
                startDate: startDate,
                endDate: endDate,
                onStartPicked: (date) => setState(() => startDate = date),
                onEndPicked: (date) => setState(() => endDate = date),
                onClear: () => setState(() {
                  startDate = null;
                  endDate = null;
                }),
              ),
              const SizedBox(height: 20,),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        FilterState(
                          selectedBanks: selectedBanks,
                          selectedCategories: selectedCategories,
                          startDate: startDate,
                          endDate: endDate,
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
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Center(
                          child: Text(
                            "Apply Filters",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }
}