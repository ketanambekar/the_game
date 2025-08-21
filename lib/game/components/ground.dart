import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/painting.dart';
import 'package:the_game/core/game_config.dart';

class Ground extends PositionComponent with CollisionCallbacks {
  Ground({required Vector2 size}) : super();

  @override
  Future<void> onLoad() async {
    // Make ground span the world width and occupy everything below groundY
    size = Vector2(GameConfig.worldSize.x, GameConfig.worldSize.y - GameConfig.groundY);
    position = Vector2(0, GameConfig.groundY);
    anchor = Anchor.topLeft;

    // Add a rectangle hitbox that uses this component's size
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    canvas.drawRect(rect, Paint()..color = const Color(0xFF8B4513));
  }
}
