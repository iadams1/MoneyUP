import 'package:flutter/material.dart';
import 'package:moneyup/shared/utils/gradient_ring_painter.dart';

class GradientRingAvatar extends StatelessWidget {
  final String assetPath;
  final double size;
  final double ringWidth;
  final double gap;      
  final double imageScale;

  const GradientRingAvatar({
    super.key,
    required this.assetPath,
    this.size = 62,
    this.ringWidth = 3,
    this.gap = 4,
    this.imageScale = 1.25,
  });

  @override
  Widget build(BuildContext context) {
    final double innerSize = size - 2 * (ringWidth + gap);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: GradientRingPainter(
          ringWidth: ringWidth,
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 255, 255, 0),
              Color.fromRGBO(255, 255, 255, 0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SizedBox(
            width: innerSize,
            height: innerSize,
            child: ClipOval(
              child: Transform.scale(
                scale: imageScale,
                child: Image.asset(assetPath, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
