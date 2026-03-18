// ── Chart ────────────────────────────────────
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:moneyup/core/theme/colors.dart';
import 'package:moneyup/models/data_model.dart';

Widget buildChart(
  PredictionData data,
  Color statusColor,
  Animation<double> lineGrow,
) {
  List<FlSpot> buildActualSpots(PredictionData data) {
    if (data.dailySpending.isEmpty) {
      return [FlSpot(0, 0)];
    }
    return data.dailySpending
        .map((d) => FlSpot(d['day']!, d['cumulative']!))
        .toList();
  }

  List<FlSpot> buildProjectedSpots(List<FlSpot> actual, PredictionData data) {
    if (actual.isEmpty) return [];
    final last = actual.last;
    return [last, FlSpot(30, data.predictedFinalSpending)];
  }

  List<FlSpot> animatedSpots(List<FlSpot> spots) {
    if (spots.isEmpty) return [];
    final progress = lineGrow.value;
    final count = (spots.length * progress).ceil().clamp(1, spots.length);
    return spots.take(count).toList();
  }

  final spots = buildActualSpots(data);
  final projectedSpots = buildProjectedSpots(spots, data);
  final maxY = ([
    data.spendingRangeHigh * 1.15,
    data.budgetAmount * 1.15,
    data.predictedFinalSpending * 1.15,
  ]).reduce((a, b) => a > b ? a : b).ceilToDouble();

  return Container(
    height: 220,
    padding: const EdgeInsets.fromLTRB(16, 16, 30, 8),
    decoration: BoxDecoration(
      color: ApiColors.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: ApiColors.muted.withOpacity(0.5), width: 1),
    ),
    child: LineChart(
      LineChartData(
        minX: 0,
        maxX: 30,
        minY: 0,
        maxY: maxY,
        clipData: const FlClipData.all(),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                if (spot.x == 0) return null;
                final now = DateTime.now();
                final date = DateTime(now.year, now.month, spot.x.toInt());
                final dateStr = '${_monthName(date.month)} ${date.day}';
                return LineTooltipItem(
                  '$dateStr\n\$${spot.y.toStringAsFixed(2)}',
                  const TextStyle(
                    fontFamily: 'SF Pro',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (_) => FlLine(
            color: const Color.fromARGB(255, 115, 115, 115).withOpacity(0.4),
            strokeWidth: 1,
            dashArray: [4, 6],
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              interval: maxY / 4,
              getTitlesWidget: (val, _) => Text(
                '\$${val.toInt()}',
                style: const TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 10,
                  color: ApiColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10,
              getTitlesWidget: (val, _) {
                if (val == 0) return const SizedBox.shrink();
                final now = DateTime.now();
                final date = DateTime(now.year, now.month, val.toInt());
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${_monthName(date.month)} ${date.day}',
                    style: const TextStyle(
                      fontFamily: 'SF Pro',
                      fontSize: 10,
                      color: ApiColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        // Confidence band
        betweenBarsData: [
          BetweenBarsData(
            fromIndex: 1,
            toIndex: 2,
            color: statusColor.withOpacity(0.06),
          ),
        ],
        lineBarsData: [
          // Budget limit line
          LineChartBarData(
            spots: [
              FlSpot(0, data.budgetAmount),
              FlSpot(30, data.budgetAmount),
            ],
            isCurved: false,
            color: ApiColors.danger.withOpacity(0.6),
            barWidth: 1.5,
            dashArray: [6, 4],
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Confidence low band
          LineChartBarData(
            spots: projectedSpots
                .map((s) => FlSpot(s.x, data.spendingRangeLow / 30 * s.x))
                .toList(),
            isCurved: true,
            color: Colors.transparent,
            barWidth: 0,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Confidence high band
          LineChartBarData(
            spots: projectedSpots
                .map((s) => FlSpot(s.x, data.spendingRangeHigh / 30 * s.x))
                .toList(),
            isCurved: true,
            color: Colors.transparent,
            barWidth: 0,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Projected line (dotted)
          LineChartBarData(
            spots: projectedSpots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: statusColor.withOpacity(0.5),
            barWidth: 2,
            dashArray: [5, 4],
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Actual spending line
          LineChartBarData(
            spots: animatedSpots(spots),
            isCurved: true,
            curveSmoothness: 0.35,
            color: statusColor,
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (spot, _) => spot == spots.last,
              getDotPainter: (_, _, _, _) => FlDotCirclePainter(
                radius: 5,
                color: statusColor,
                strokeWidth: 2,
                strokeColor: ApiColors.bg,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  statusColor.withOpacity(0.15),
                  statusColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}
