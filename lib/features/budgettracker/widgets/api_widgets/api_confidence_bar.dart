// ── Confidence Bar ───────────────────────────
import 'package:flutter/material.dart';
import 'package:moneyup/core/theme/colors.dart';
import 'package:moneyup/models/data_model.dart';

Widget buildConfidenceBar(PredictionData data, Color statusColor) {
    final low = data.spendingRangeLow;
    final high = data.spendingRangeHigh;
    final predicted = data.predictedFinalSpending;
    final budget = data.budgetAmount;
    final maxVal = high * 1.1;

    final budgetPos = (budget / maxVal).clamp(0.0, 1.0);
    final predictedPos = (predicted / maxVal).clamp(0.0, 1.0);
    final lowPos = (low / maxVal).clamp(0.0, 1.0);
    final highPos = (high / maxVal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ApiColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ApiColors.muted.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CONFIDENCE RANGE',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: ApiColors.textSecondary,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, constraints) {
            final w = constraints.maxWidth;
            return SizedBox(
              height: 40,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Track
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: ApiColors.muted.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Confidence band
                  Positioned(
                    left: lowPos * w,
                    width: (highPos - lowPos) * w,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Budget marker
                  Positioned(
                    left: (budgetPos * w - 1).clamp(0, w - 2),
                    child: Container(
                      width: 2,
                      height: 20,
                      decoration: BoxDecoration(
                        color: ApiColors.danger.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  // Predicted dot
                  Positioned(
                    left: (predictedPos * w - 6).clamp(0, w - 12),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: statusColor.withOpacity(0.5), blurRadius: 6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Low: \$${low.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 11,
                  color: ApiColors.textSecondary,
                ),
              ),
              Text(
                'Predicted: \$${predicted.toStringAsFixed(0)}',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
              Text(
                'High: \$${high.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 11,
                  color: ApiColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
