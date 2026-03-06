class FilterState {
  final Set<String> selectedBanks;
  final Set<String> selectedCategories;
  final DateTime? startDate;
  final DateTime? endDate;

  FilterState({
    this.selectedBanks = const {},
    this.selectedCategories = const {},
    this.startDate,
    this.endDate,
  });

  bool get hasFilters => 
    selectedBanks.isNotEmpty ||
    selectedCategories.isNotEmpty ||
    startDate != null ||
    endDate != null;

  FilterState copyWith({
    Set<String>? selectedBanks,
    Set<String>? selectedCategories,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return FilterState (
      selectedBanks: selectedBanks ?? this.selectedBanks,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}