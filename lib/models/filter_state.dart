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

  factory FilterState.empty() {
    return FilterState(
      selectedBanks: {},
      selectedCategories: {},
      startDate: null,
      endDate: null,
    );
  }

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
    bool clearStartDate = false,
    bool clearEndDate = false,
  }) {
    return FilterState (
      selectedBanks: selectedBanks ?? this.selectedBanks,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
    );
  }
}