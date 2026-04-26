// ── Stats Row ────────────────────────────────
import 'package:flutter/material.dart';
import 'package:moneyup/core/constants/app_colors.dart';
import 'package:moneyup/models/data_model.dart';

Widget buildStatsRow(PredictionData data, bool isOver, Color statusColor) {
  return Row(
    children: [
      Expanded(
        child: _statCard(
          'Spent so far',
          '\$${data.currentSpent.toStringAsFixed(2)}',
          ApiColors.textPrimary,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _statCard(
          'Remaining',
          '\$${(data.budgetAmount - data.currentSpent).toStringAsFixed(2)}',
          isOver ? ApiColors.danger : ApiColors.accent,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _statCard(
          isOver ? 'Over by' : 'Under by',
          '\$${data.predictedOverage.abs().toStringAsFixed(2)}',
          statusColor,
        ),
      ),
    ],
  );
}

Widget _statCard(String label, String value, Color valueColor) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      color: ApiColors.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: ApiColors.muted.withOpacity(0.5), width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: ApiColors.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    ),
  );
}
