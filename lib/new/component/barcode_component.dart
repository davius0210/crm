import 'package:crm_apps/new/helper/color_helper.dart';
import 'package:flutter/material.dart';

class BarcodeSeparator extends StatelessWidget {
  final double height;
  final double barWidth;
  final double spacing;

  const BarcodeSeparator({
    super.key,
    this.height = 30,
    this.barWidth = 2,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: _BarcodeSeparatorPainter(barWidth: barWidth, spacing: spacing),
    );
  }
}

class _BarcodeSeparatorPainter extends CustomPainter {
  final double barWidth;
  final double spacing;

  _BarcodeSeparatorPainter({required this.barWidth, required this.spacing});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    final double totalUnit = barWidth + spacing;

    final int barCount = (size.width / totalUnit).floor();

    for (int i = 0; i < barCount; i++) {
      final double x = i * totalUnit;

      final Rect rect = Rect.fromLTWH(x, 0, barWidth, size.height);

      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [ColorHelper.border, Colors.transparent],
      ).createShader(rect);

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}