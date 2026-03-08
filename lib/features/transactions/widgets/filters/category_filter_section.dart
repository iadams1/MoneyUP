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
              label: Text(
                Formatters.category(category),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              selected: selectedCategories.contains(category),
              onSelected: (_) => onToggle(category),
              selectedColor: const Color.fromARGB(255, 231, 221, 255),
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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