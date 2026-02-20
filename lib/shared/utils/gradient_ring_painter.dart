import 'dart:math' as math;

import 'package:flutter/material.dart';

class GradientRingPainter extends CustomPainter {
  final double ringWidth;
  final Gradient gradient;

  GradientRingPainter({
    required this.ringWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringWidth
      ..shader = gradient.createShader(rect);

    final radius = (math.min(size.width, size.height) / 2) - ringWidth / 2;
    canvas.drawCircle(size.center(Offset.zero), radius, paint);
  }

  @override
  bool shouldRepaint(covariant GradientRingPainter old) {
    return old.ringWidth != ringWidth || old.gradient != gradient;
  }
}