import 'package:flame/components.dart';

class GameConfig {
  static final worldSize = Vector2(2000, 1080); // logical pixels
  static const gravity = 1600.0;
  static const moveSpeed = 320.0;
  static const jumpSpeed = 720.0;
  static const groundY = 820.0; // y for the "floor"
}
