import 'package:flutter/material.dart';
import 'package:moneyup/models/data_model.dart';
import 'package:moneyup/core/theme/colors.dart';

Widget buildBudgetPill(PredictionData data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: ApiColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ApiColors.muted, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'BUDGET',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: ApiColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            '\$${data.budgetAmount.toStringAsFixed(0)}',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ApiColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }