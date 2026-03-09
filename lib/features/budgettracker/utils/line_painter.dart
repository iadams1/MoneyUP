// ─────────────────────────────────────────────
// HELPER: Line painter for legend
// ─────────────────────────────────────────────
import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final Color color;
  final bool dashed;

  LinePainter({required this.color, required this.dashed});

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
  bool shouldRepaint(LinePainter old) => old.color != color || old.dashed != dashed;
}