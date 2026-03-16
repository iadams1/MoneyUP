 // ── Status Banner ────────────────────────────
  import 'package:flutter/material.dart';
import 'package:moneyup/core/utils/formatters.dart';
import 'package:moneyup/models/data_model.dart';

Widget buildStatusBanner(PredictionData data, bool isOver, Color statusColor) {
    final pct = data.percentageOverUnder.abs().toStringAsFixed(1);
    final label = isOver
        ? 'Projected to exceed budget by $pct%'
        : 'Projected to stay under budget by $pct%';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withOpacity(0.25), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: statusColor.withOpacity(0.5), blurRadius: 6)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
          Text(
            Formatters.currency(data.predictedFinalSpending),
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }