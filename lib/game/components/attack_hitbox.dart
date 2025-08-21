import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dummy_target.dart';
import 'player.dart';

class AttackHitbox extends PositionComponent with CollisionCallbacks {
  final Vector2 offset;
  final double damage;
  final PositionComponent owner; // 👈 new
  late RectangleHitbox hitbox;

  AttackHitbox({
    required this.offset,
    required Vector2 size,
    required this.damage,
    required this.owner,
  }) {
    this.size = size;
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    hitbox = RectangleHitbox();
    add(hitbox);
    position = offset;
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.orange.withOpacity(0.5);
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other == owner) return; // 👈 ignore self

    // if (other is Player) {
    //   other.takeHit(damage);
    // } else if (other is DummyTarget) {
    //   other.takeHit(damage);
    // }
  }
}
