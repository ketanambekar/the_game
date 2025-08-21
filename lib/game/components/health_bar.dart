import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HealthBar extends PositionComponent {
  double maxHp;
  double currentHp;
  final double barWidth;
  final double barHeight;

  HealthBar({
    required this.maxHp,
    required this.currentHp,
    this.barWidth = 50,
    this.barHeight = 6,
  });

  void updateHp(double value) {
    currentHp = value.clamp(0, maxHp);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final bgPaint = Paint()..color = Colors.black;
    final hpPercent = currentHp / maxHp;
    final hpPaint = Paint()
      ..color = hpPercent > 0.5
          ? Colors.green
          : hpPercent > 0.25
          ? Colors.orange
          : Colors.red;

    // Draw background bar
    canvas.drawRect(
      Rect.fromLTWH(0, 0, barWidth, barHeight),
      bgPaint,
    );

    // Draw health portion
    canvas.drawRect(
      Rect.fromLTWH(0, 0, barWidth * hpPercent, barHeight),
      hpPaint,
    );
  }
}
