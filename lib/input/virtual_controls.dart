import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:the_game/game/components/player.dart';

class VirtualControls extends PositionComponent with TapCallbacks, HasGameRef {
  late Player player;

  VirtualControls(this.player) : super();

  @override
  Future<void> onLoad() async {
    size = Vector2(300, 140);
    anchor = Anchor.topLeft;
    position = Vector2(24, gameRef.size.y - size.y - 24);
  }

  @override
  bool containsPoint(Vector2 point) => true;

  @override
  void onTapDown(TapDownEvent event) {
    final p = event.localPosition;

    if (p.y < size.y * 0.5) {
      // Top half = jump
      player.jump();
    } else {
      // Bottom half = left / right / punch / defend
      if (p.x < size.x * 0.2) {
        player.moveLeft(run: true);
      } else if (p.x < size.x * 0.4) {
        player.moveLeft(run: false);
      } else if (p.x < size.x * 0.6) {
        player.punch();
      } else if (p.x < size.x * 0.8) {
        player.defend();
      } else {
        player.moveRight(run: false);
      }
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    // Stop horizontal movement when touch ends
    player.stopMoving();
  }
}
