// ── Legend ───────────────────────────────────
import 'package:flutter/material.dart';
import 'package:moneyup/core/theme/colors.dart';
import 'package:moneyup/features/budgettracker/utils/line_painter.dart';

Widget buildLegend(Color statusColor) {
    return Row(
      children: [
        _legendItem(statusColor, 'Actual', false),
        const SizedBox(width: 20),
        _legendItem(statusColor.withOpacity(0.5), 'Projected', true),
        const SizedBox(width: 20),
        _legendItem(ApiColors.danger.withOpacity(0.6), 'Budget limit', true),
      ],
    );
  }

  Widget _legendItem(Color color, String label, bool dashed) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: CustomPaint(painter: LinePainter(color: color, dashed: dashed)),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 11,
            color: ApiColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
