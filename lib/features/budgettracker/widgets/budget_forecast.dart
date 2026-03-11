import 'package:flutter/material.dart';
import 'package:moneyup/core/theme/colors.dart' show ApiColors;
import 'package:moneyup/features/budgettracker/widgets/api_widgets/api_chart.dart';
import 'package:moneyup/features/budgettracker/widgets/api_widgets/api_confidence_bar.dart';
import 'package:moneyup/features/budgettracker/widgets/api_widgets/api_legend.dart';
import 'package:moneyup/features/budgettracker/widgets/api_widgets/api_stats.dart';
import 'package:moneyup/features/budgettracker/widgets/api_widgets/api_status_banner.dart';
import 'package:moneyup/models/data_model.dart';
import 'package:moneyup/services/budget_response.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:moneyup/features/budgettracker/widgets/api_widgets/api_header.dart';

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

class _BudgetPredictionChartState extends State<BudgetPredictionChart> with SingleTickerProviderStateMixin {
      
  final _service = apiService;
  PredictionResult? _result;
  bool _loading = true;
  String? _error;
  List<Map<String, double>> _dailySpending = [];

  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _lineGrow;

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
      final daily = await _service.getTransactionSpending(budgetId: widget.budgetId);
      
      setState(() {
        _result = result;
        _dailySpending = daily;
        _loading = false;
    });
    _controller.forward();
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
  Color get _statusColor => _isOver ? ApiColors.danger :ApiColors. accent;

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
    dailySpending: _dailySpending,
  );

  return AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      return Container(
        decoration: const BoxDecoration(color: ApiColors.bg),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: FadeTransition(
            opacity: _fadeIn,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(data),
                const SizedBox(height: 24),
                buildStatusBanner(data, _isOver, _statusColor),
                const SizedBox(height: 24),
                buildChart(data, _statusColor, _lineGrow),
                const SizedBox(height: 20),
                buildLegend(_statusColor),
                const SizedBox(height: 24),
                buildStatsRow(data, _isOver, _statusColor),
                const SizedBox(height: 24),
                buildConfidenceBar(data, _statusColor),
              ],
            ),
          ),
        ),
      );
    },
  );
}}

// ─────────────────────────────────────────────
// PREVIEW WRAPPER
// Run this file directly in Flutter Widget Preview
// ─────────────────────────────────────────────
// @Preview()
// Widget previewBudgetChart() {
//   return MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData.dark(),
//     home: Scaffold(
//       backgroundColor: const Color(0xFF0D0D0F),
//       body: SafeArea(
//         child: BudgetPredictionChart(
//           userId: 'preview-user',
//           budgetId: 1,
//         ),
//       ),
//     ),
//   );
// }