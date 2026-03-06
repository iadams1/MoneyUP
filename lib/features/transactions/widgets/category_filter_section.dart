import 'package:flutter/material.dart';

import '/core/utils/formatters.dart';
import 'filter_section_header.dart';

class CategoryFilterSection extends StatelessWidget {
  final List<String> categories;
  final Set<String> selectedCategories;
  final Function(String) onToggle;
  final VoidCallback onClear;

  const CategoryFilterSection({
    super.key,
    required this.categories,
    required this.selectedCategories,
    required this.onToggle,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionHeader(
          title: "Categories",
          showClear: selectedCategories.isNotEmpty,
          onClear: onClear,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            return FilterChip(
              label: Text(Formatters.category(category)),
              selected: selectedCategories.contains(category),
              onSelected: (_) => onToggle(category),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          }).toList(),
        ),
      ],
    );
  }
}