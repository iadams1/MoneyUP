import 'package:flutter/material.dart';

import 'filter_section_header.dart';

class DateFilterSection extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime) onStartPicked;
  final Function(DateTime) onEndPicked;
  final VoidCallback onClear;

  const DateFilterSection({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartPicked,
    required this.onEndPicked,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FilterSectionHeader(
          title: "Date & Time",
          showClear: startDate != null || endDate != null,
          onClear: onClear,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _datePicker(context, "Start", startDate, onStartPicked),
            _datePicker(context, "End", endDate, onEndPicked),
          ],
        ),
      ],
    );
  }

  Widget _datePicker(
    BuildContext context,
    String label,
    DateTime? value,
    Function(DateTime) onPicked,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),

              helpText: 'Select a Date',
              cancelText: 'Close',
              confirmText: 'Confirm',
              fieldHintText: 'MM/DD/YYYY',
              fieldLabelText: 'Enter date',

              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color.fromARGB(255, 30, 28, 117), 
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                    dialogTheme: const DialogThemeData(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) onPicked(picked);
          },
          child: Text(
            value != null
                ? "${value.month}/${value.day}/${value.year}"
                : "MM/DD/YYYY",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
