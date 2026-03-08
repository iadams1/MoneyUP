import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widget_previews.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

// ─────────────────────────────────────────────
// DATA MODEL
// Mirrors your FastAPI PredictionResponse
// ─────────────────────────────────────────────
class PredictionData {
  final double budgetAmount;
  final double currentSpent;
  final double predictedFinalSpending;
  final double predictedOverage;
  final double percentageOverUnder;
  final String status; // 'over' or 'under'
  final String categoryName;
  final double spendingRangeLow;
  final double spendingRangeHigh;

  // Day-by-day actual spending (from your transactions)
  // Each entry: {'day': 1, 'cumulative': 45.20}
  final List<Map<String, double>> dailySpending;

  const PredictionData({
    required this.budgetAmount,
    required this.currentSpent,
    required this.predictedFinalSpending,
    required this.predictedOverage,
    required this.percentageOverUnder,
    required this.status,
    required this.categoryName,
    required this.spendingRangeLow,
    required this.spendingRangeHigh,
    required this.dailySpending,
  });
}

class PredictionResult {
  final bool success;
  final String? message;
  final double? budgetAmount;
  final double? currentSpent;
  final double? predictedFinalSpending;
  final double? predictedOverage;
  final Map<String, dynamic>? predictedSpendingRange;
  final String? status;
  final double? percentageOverUnder;
  final String? categoryName;

  PredictionResult({
    required this.success,
    this.message,
    this.budgetAmount,
    this.currentSpent,
    this.predictedFinalSpending,
    this.predictedOverage,
    this.predictedSpendingRange,
    this.status,
    this.percentageOverUnder,
    this.categoryName,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      success: json['success'],
      message: json['message'],
      budgetAmount: (json['budget_amount'] as num?)?.toDouble(),
      currentSpent: (json['current_spent'] as num?)?.toDouble(),
      predictedFinalSpending: (json['predicted_final_spending'] as num?)?.toDouble(),
      predictedOverage: (json['predicted_overage'] as num?)?.toDouble(),
      predictedSpendingRange: json['predicted_spending_range'],
      status: json['status'],
      percentageOverUnder: (json['percentage_over_under'] as num?)?.toDouble(),
      categoryName: json['category_name'],
    );
  }
}

class PredictionService {
  static const String _baseUrl = 'http://10.0.2.2:8000';

  Future<PredictionResult> getPrediction({required int budgetId}) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) throw Exception('No user logged in');

    final response = await http.post(
      Uri.parse('$_baseUrl/predict'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'budget_id': budgetId}),
    );

    if (response.statusCode == 200) {
      return PredictionResult.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Prediction failed: ${response.body}');
    }
  }
}

// ─────────────────────────────────────────────
// MAIN WIDGET
// ─────────────────────────────────────────────
class BudgetPredictionChart extends StatefulWidget {
  final String userId;
  final int budgetId;

  const BudgetPredictionChart({
    super.key, 
    required this.userId,
    required this.budgetId,
  });

  @override
  State<BudgetPredictionChart> createState() => _BudgetPredictionChartState();
}

class _BudgetPredictionChartState extends State<BudgetPredictionChart>
    with SingleTickerProviderStateMixin {
      
  final _service = PredictionService();
  PredictionResult? _result;
  bool _loading = true;
  String? _error;

  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _lineGrow;

  // Colors
  static const Color _bg = Color(0xFF0D0D0F);
  static const Color _card = Color(0xFF17171A);
  static const Color _accent = Color(0xFF00E5A0);
  static const Color _danger = Color(0xFFFF4D6A);
  static const Color _muted = Color(0xFF3A3A40);
  static const Color _textPrimary = Color(0xFFF5F5F7);
  static const Color _textSecondary = Color(0xFF8E8E9A);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeOut));
    _lineGrow = CurvedAnimation(parent: _controller, curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic));
    _controller.forward();
    _fetchPrediction();
  }

  Future<void> _fetchPrediction() async {
    try {
      final result = await _service.getPrediction(budgetId: widget.budgetId);
      setState(() {
        _result = result;
        _loading = false;
      });
      _controller.forward(); // animate only after data arrives
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isOver => _result?.status == 'over';
  Color get _statusColor => _isOver ? _danger : _accent;

  @override
  Widget build(BuildContext context) {
  if (_loading) {
    return const Center(child: CircularProgressIndicator(color: Color(0xFF00E5A0)));
  }
  if (_error != null) {
    return Center(child: Text('Error: $_error', style: const TextStyle(color: Colors.red)));
  }
  if (_result == null || !_result!.success) {
    return Center(child: Text(_result?.message ?? 'No data', style: const TextStyle(color: Colors.white)));
  }

  // convert _result to PredictionData for the chart methods
  final data = PredictionData(
    budgetAmount: _result!.budgetAmount ?? 0,
    currentSpent: _result!.currentSpent ?? 0,
    predictedFinalSpending: _result!.predictedFinalSpending ?? 0,
    predictedOverage: _result!.predictedOverage ?? 0,
    percentageOverUnder: _result!.percentageOverUnder ?? 0,
    status: _result!.status ?? 'under',
    categoryName: _result!.categoryName ?? 'Budget',
    spendingRangeLow: (_result!.predictedSpendingRange?['low'] as num?)?.toDouble() ?? 0,
    spendingRangeHigh: (_result!.predictedSpendingRange?['high'] as num?)?.toDouble() ?? 0,
    dailySpending: const [],
  );

  return AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      return Container(
        decoration: const BoxDecoration(color: _bg),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: FadeTransition(
            opacity: _fadeIn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(data),
                const SizedBox(height: 24),
                _buildStatusBanner(data),
                const SizedBox(height: 24),
                _buildChart(data),
                const SizedBox(height: 20),
                _buildLegend(),
                const SizedBox(height: 24),
                _buildStatsRow(data),
                const SizedBox(height: 24),
                _buildConfidenceBar(data),
              ],
            ),
          ),
        ),
      );
    },
  );
}

  // ── Header ──────────────────────────────────
  Widget _buildHeader(PredictionData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.categoryName.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _textSecondary,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Budget Forecast',
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        _buildBudgetPill(data),
      ],
    );
  }

  Widget _buildBudgetPill(PredictionData data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _muted, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'BUDGET',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: _textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            '\$${data.budgetAmount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Status Banner ────────────────────────────
  Widget _buildStatusBanner(PredictionData data) {
    final pct = data.percentageOverUnder.abs().toStringAsFixed(1);
    final label = _isOver
        ? 'Projected to exceed budget by $pct%'
        : 'Projected to stay under budget by $pct%';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _statusColor.withOpacity(0.25), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _statusColor,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: _statusColor.withOpacity(0.5), blurRadius: 6)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'SF Pro',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _statusColor,
              ),
            ),
          ),
          Text(
            '\$${data.predictedFinalSpending.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _statusColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Chart ────────────────────────────────────
  Widget _buildChart(PredictionData data) {
    final spots = _buildActualSpots(data);
    final projectedSpots = _buildProjectedSpots(spots, data);
    final maxY = (data.spendingRangeHigh * 1.15).ceilToDouble();

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(4, 16, 16, 8),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _muted.withOpacity(0.5), width: 1),
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 30,
          minY: 0,
          maxY: maxY,
          clipData: const FlClipData.all(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (_) => FlLine(
              color: _muted.withOpacity(0.4),
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
                    color: _textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                getTitlesWidget: (val, _) => Text(
                  'Day ${val.toInt()}',
                  style: const TextStyle(
                    fontFamily: 'SF Pro',
                    fontSize: 10,
                    color: _textSecondary,
                  ),
                ),
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          // Confidence band
          betweenBarsData: [
            BetweenBarsData(
              fromIndex: 1,
              toIndex: 2,
              color: _statusColor.withOpacity(0.06),
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
              color: _danger.withOpacity(0.6),
              barWidth: 1.5,
              dashArray: [6, 4],
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
            // Confidence low band
            LineChartBarData(
              spots: projectedSpots.map((s) => FlSpot(s.x, data.spendingRangeLow / 30 * s.x)).toList(),
              isCurved: true,
              color: Colors.transparent,
              barWidth: 0,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
            // Confidence high band
            LineChartBarData(
              spots: projectedSpots.map((s) => FlSpot(s.x, data.spendingRangeHigh / 30 * s.x)).toList(),
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
              color: _statusColor.withOpacity(0.5),
              barWidth: 2,
              dashArray: [5, 4],
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
            // Actual spending line
            LineChartBarData(
              spots: _animatedSpots(spots),
              isCurved: true,
              curveSmoothness: 0.35,
              color: _statusColor,
              barWidth: 2.5,
              dotData: FlDotData(
                show: true,
                checkToShowDot: (spot, _) => spot == spots.last,
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 5,
                  color: _statusColor,
                  strokeWidth: 2,
                  strokeColor: _bg,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _statusColor.withOpacity(0.15),
                    _statusColor.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _buildActualSpots(PredictionData data) {
    if (data.dailySpending.isEmpty) {
      return [FlSpot(0, 0)];
    }
    return data.dailySpending
        .map((d) => FlSpot(d['day']!, d['cumulative']!))
        .toList();
  }

  List<FlSpot> _buildProjectedSpots(List<FlSpot> actual, PredictionData data) {
    if (actual.isEmpty) return [];
    final last = actual.last;
    return [
      last,
      FlSpot(30, data.predictedFinalSpending),
    ];
  }

  List<FlSpot> _animatedSpots(List<FlSpot> spots) {
    if (spots.isEmpty) return [];
    final progress = _lineGrow.value;
    final count = (spots.length * progress).ceil().clamp(1, spots.length);
    return spots.take(count).toList();
  }

  // ── Legend ───────────────────────────────────
  Widget _buildLegend() {
    return Row(
      children: [
        _legendItem(_statusColor, 'Actual', false),
        const SizedBox(width: 20),
        _legendItem(_statusColor.withOpacity(0.5), 'Projected', true),
        const SizedBox(width: 20),
        _legendItem(_danger.withOpacity(0.6), 'Budget limit', true),
      ],
    );
  }

  Widget _legendItem(Color color, String label, bool dashed) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: CustomPaint(painter: _LinePainter(color: color, dashed: dashed)),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 11,
            color: _textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ── Stats Row ────────────────────────────────
  Widget _buildStatsRow(PredictionData data) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            'Spent so far',
            '\$${data.currentSpent.toStringAsFixed(2)}',
            _textPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            'Remaining',
            '\$${(data.budgetAmount - data.currentSpent).toStringAsFixed(2)}',
            _isOver ? _danger : _accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            _isOver ? 'Over by' : 'Under by',
            '\$${data.predictedOverage.abs().toStringAsFixed(2)}',
            _statusColor,
          ),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _muted.withOpacity(0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: _textSecondary,
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

  // ── Confidence Bar ───────────────────────────
  Widget _buildConfidenceBar(PredictionData data) {
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
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _muted.withOpacity(0.5), width: 1),
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
              color: _textSecondary,
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
                      color: _muted.withOpacity(0.4),
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
                        color: _statusColor.withOpacity(0.3),
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
                        color: _danger.withOpacity(0.8),
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
                        color: _statusColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: _statusColor.withOpacity(0.5), blurRadius: 6),
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
                  color: _textSecondary,
                ),
              ),
              Text(
                'Predicted: \$${predicted.toStringAsFixed(0)}',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _statusColor,
                ),
              ),
              Text(
                'High: \$${high.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 11,
                  color: _textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HELPER: Line painter for legend
// ─────────────────────────────────────────────
class _LinePainter extends CustomPainter {
  final Color color;
  final bool dashed;

  _LinePainter({required this.color, required this.dashed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (dashed) {
      double x = 0;
      while (x < size.width) {
        canvas.drawLine(Offset(x, size.height / 2), Offset((x + 4).clamp(0, size.width), size.height / 2), paint);
        x += 8;
      }
    } else {
      canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.color != color || old.dashed != dashed;
}

// ─────────────────────────────────────────────
// PREVIEW WRAPPER
// Run this file directly in Flutter Widget Preview
// ─────────────────────────────────────────────
@Preview()
Widget previewBudgetChart() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      body: SafeArea(
        child: BudgetPredictionChart(
          userId: 'preview-user',
          budgetId: 1,
        ),
      ),
    ),
  );
}