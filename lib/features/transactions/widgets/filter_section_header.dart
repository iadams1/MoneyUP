import 'package:flutter/material.dart';

class FilterSectionHeader extends StatelessWidget{
  final String title;
  final bool showClear;
  final VoidCallback? onClear;

  const FilterSectionHeader({
    super.key,
    required this.title,
    required this.showClear,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showClear)
          GestureDetector(
            onTap: onClear,
            child: const Text(
              "Clear ✕",
              style: TextStyle(
                color: Color.fromRGBO(117, 117, 117, 1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}