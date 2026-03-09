import 'package:flutter/material.dart';
import 'package:moneyup/core/theme/colors.dart';
import 'package:moneyup/features/budgettracker/widgets/api_widgets/api_budget_pill.dart';
import 'package:moneyup/models/data_model.dart';

Widget buildHeader(PredictionData data, ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.categoryName.toUpperCase(),
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ApiColors.textSecondary,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Budget Forecast',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: ApiColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        buildBudgetPill(data),
      ],
    );
  }