// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:moneyup/models/prediction_model.dart';

// class BudgetGraph extends StatelessWidget {
//   final BudgetPrediction prediction;
  
//   const BudgetGraph({Key? key, required this.prediction}) : super(key: key);
  
//   @override
//   Widget build(BuildContext context) {
//     // GET YOUR APP'S THEME COLORS
//     final primaryColor = Theme.of(context).primaryColor;
//     final accentColor = Theme.of(context).colorScheme.secondary;
    
//     return Container(
//       height: 300,
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Graph title and legend
//           _buildLegend(context, primaryColor, accentColor),
//           SizedBox(height: 16),
          
//           // The actual graph
//           Expanded(
//             child: LineChart(
//               LineChartData(
//                 // CUSTOM GRID
//                 gridData: FlGridData(
//                   show: true,
//                   drawVerticalLine: true,
//                   horizontalInterval: 50,  // Grid lines every $50
//                   getDrawingHorizontalLine: (value) {
//                     return FlLine(
//                       color: Colors.grey[300],
//                       strokeWidth: 1,
//                     );
//                   },
//                   getDrawingVerticalLine: (value) {
//                     return FlLine(
//                       color: Colors.grey[300],
//                       strokeWidth: 1,
//                     );
//                   },
//                 ),
                
//                 // YOUR DATA LINES
//                 lineBarsData: [
//                   // Current spending - solid blue line
//                   LineChartBarData(
//                     spots: [
//                       FlSpot(0, prediction.currentSpent ?? 0),
//                     ],
//                     color: primaryColor,
//                     barWidth: 4,
//                     isStrokeCapRound: true,
//                     dotData: FlDotData(
//                       show: true,
//                       getDotPainter: (spot, percent, barData, index) {
//                         return FlDotCirclePainter(
//                           radius: 6,
//                           color: primaryColor,
//                           strokeWidth: 2,
//                           strokeColor: Colors.white,
//                         );
//                       },
//                     ),
//                   ),
                  
//                   // Predicted spending - dashed orange line
//                   LineChartBarData(
//                     spots: [
//                       FlSpot(0, prediction.currentSpent ?? 0),
//                       FlSpot(1, prediction.predictedFinalSpending ?? 0),
//                     ],
//                     color: accentColor,
//                     barWidth: 3,
//                     dashArray: [8, 4],  // Makes it dashed
//                     dotData: FlDotData(
//                       show: true,
//                       getDotPainter: (spot, percent, barData, index) {
//                         return FlDotCirclePainter(
//                           radius: 5,
//                           color: accentColor,
//                           strokeWidth: 2,
//                           strokeColor: Colors.white,
//                         );
//                       },
//                     ),
//                   ),
                  
//                   // Budget line - horizontal red/green line
//                   LineChartBarData(
//                     spots: [
//                       FlSpot(0, prediction.budgetAmount ?? 0),
//                       FlSpot(1, prediction.budgetAmount ?? 0),
//                     ],
//                     color: prediction.status == 'over' ? Colors.red : Colors.green,
//                     barWidth: 2,
//                     dashArray: [10, 5],
//                     dotData: FlDotData(show: false),
//                   ),
//                 ],
                
//                 // CUSTOM LABELS
//                 titlesData: FlTitlesData(
//                   // Left side (Y-axis) - Dollar amounts
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       interval: 50,
//                       getTitlesWidget: (value, meta) {
//                         return Padding(
//                           padding: EdgeInsets.only(right: 8),
//                           child: Text(
//                             '\$${value.toInt()}',
//                             style: TextStyle(
//                               color: Colors.grey[700],
//                               fontWeight: FontWeight.w600,
//                               fontSize: 11,
//                             ),
//                           ),
//                         );
//                       },
//                       reservedSize: 50,
//                     ),
//                   ),
                  
//                   // Bottom (X-axis) - Time labels
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         if (value == 0) {
//                           return Text(
//                             'Today',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           );
//                         }
//                         if (value == 1) {
//                           return Text(
//                             'End of Period',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           );
//                         }
//                         return Text('');
//                       },
//                     ),
//                   ),
                  
//                   // Hide right and top axes
//                   rightTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                 ),
                
//                 // BORDER STYLING
//                 borderData: FlBorderData(
//                   show: true,
//                   border: Border(
//                     bottom: BorderSide(color: Colors.grey[400]!, width: 2),
//                     left: BorderSide(color: Colors.grey[400]!, width: 2),
//                   ),
//                 ),
                
//                 // MIN/MAX VALUES (auto-calculate good range)
//                 minY: 0,
//                 maxY: _calculateMaxY(),
                
//                 // MAKE IT INTERACTIVE - Show values when tapped
//                 lineTouchData: LineTouchData(
//                   touchTooltipData: LineTouchTooltipData(
//                     tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
//                     getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
//                       return touchedBarSpots.map((barSpot) {
//                         final label = barSpot.x == 0 ? 'Current' : 'Predicted';
//                         return LineTooltipItem(
//                           '$label\n\$${barSpot.y.toStringAsFixed(2)}',
//                           TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                         );
//                       }).toList();
//                     },
//                   ),
//                   handleBuiltInTouches: true,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   // Helper: Build legend at top of graph
//   Widget _buildLegend(BuildContext context, Color primaryColor, Color accentColor) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         _buildLegendItem('Current', primaryColor, solid: true),
//         _buildLegendItem('Predicted', accentColor, solid: false),
//         _buildLegendItem(
//           'Budget',
//           prediction.status == 'over' ? Colors.red : Colors.green,
//           solid: false,
//         ),
//       ],
//     );
//   }
  
//   Widget _buildLegendItem(String label, Color color, {required bool solid}) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 20,
//           height: 3,
//           decoration: BoxDecoration(
//             color: color,
//             border: solid ? null : Border.all(color: color, width: 2),
//           ),
//           child: solid
//               ? null
//               : CustomPaint(
//                   painter: DashedLinePainter(color: color),
//                 ),
//         ),
//         SizedBox(width: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 11,
//             fontWeight: FontWeight.w500,
//             color: Colors.grey[700],
//           ),
//         ),
//       ],
//     );
//   }
  
//   // Helper: Calculate good max Y value for graph
//   double _calculateMaxY() {
//     final values = [
//       prediction.currentSpent ?? 0,
//       prediction.predictedFinalSpending ?? 0,
//       prediction.budgetAmount ?? 0,
//       prediction.predictedSpendingRange?.high ?? 0,
//     ];
    
//     final maxValue = values.reduce((a, b) => a > b ? a : b);
    
//     // Add 20% padding above highest value
//     return (maxValue * 1.2).ceilToDouble();
//   }
// }

// // Custom painter for dashed lines in legend
// class DashedLinePainter extends CustomPainter {
//   final Color color;
  
//   DashedLinePainter({required this.color});
  
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = 2;
    
//     const dashWidth = 3;
//     const dashSpace = 2;
//     double startX = 0;
    
//     while (startX < size.width) {
//       canvas.drawLine(
//         Offset(startX, size.height / 2),
//         Offset(startX + dashWidth, size.height / 2),
//         paint,
//       );
//       startX += dashWidth + dashSpace;
//     }
//   }
  
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }