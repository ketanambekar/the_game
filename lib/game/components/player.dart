import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:the_game/core/game_config.dart';
import 'package:the_game/utils/assets.dart';

enum PlayerState { idle, walk, run, jump, punch, defend }

class Player extends SpriteAnimationComponent with HasGameRef {
  late SpriteAnimation idleAnimation;
  late SpriteAnimation walkAnimation;
  late SpriteAnimation runAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation punchAnimation;
  late SpriteAnimation defendAnimation;

  // Store templates to recreate punch animation
  late Image _spriteImage;
  late SpriteAnimationData _punchAnimationData;

  PlayerState state = PlayerState.idle;
  double speed = 150;
  Vector2 velocity = Vector2.zero();
  bool facingRight = true;
  PlayerState _lastState = PlayerState.idle;

  // Flag for non-looping punch animation
  bool _isPunching = false;

  Player({required super.position}) : super(size: Vector2(90, 90));

  @override
  Future<void> onLoad() async {
    _spriteImage = await gameRef.images.load(Img.bandit);

    idleAnimation = SpriteAnimation.fromFrameData(
      _spriteImage,
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.15,
        textureSize: Vector2(90, 90),
      ),
    );

    walkAnimation = SpriteAnimation.fromFrameData(
      _spriteImage,
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.10,
        textureSize: Vector2(90, 90),
      ),
    );

    runAnimation = SpriteAnimation.fromFrameData(
      _spriteImage,
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: 0.08,
        textureSize: Vector2(90, 90),
      ),
    );

    jumpAnimation = SpriteAnimation.fromFrameData(
      _spriteImage,
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: 0.20,
        textureSize: Vector2(90, 90),
      ),
    );

    // Store punch animation template data
    _punchAnimationData = SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.08,
      textureSize: Vector2(90, 90),
      loop: false,
    );

    punchAnimation = SpriteAnimation.fromFrameData(_spriteImage, _punchAnimationData);

    defendAnimation = SpriteAnimation.fromFrameData(
      _spriteImage,
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 0.5,
        textureSize: Vector2(90, 90),
        loop: true,
      ),
    );

    animation = idleAnimation;
  }

  // --- Movement controls ---
  void moveLeft({bool run = false}) {
    facingRight = false;
    velocity.x = run ? -speed * 1.5 : -speed;
    state = run ? PlayerState.run : PlayerState.walk;
  }

  void moveRight({bool run = false}) {
    facingRight = true;
    velocity.x = run ? speed * 1.5 : speed;
    state = run ? PlayerState.run : PlayerState.walk;
  }

  void stopMoving() {
    velocity.x = 0;
    state = PlayerState.idle;
  }

  void jump() {
    if (isOnGround) {
      velocity.y = -400;
      state = PlayerState.jump;
    }
  }

  void punch() {
    if (!_isPunching) {
      state = PlayerState.punch;
      _isPunching = true;
      animation = SpriteAnimation.fromFrameData(_spriteImage, _punchAnimationData);
    }
  }

  void defend() {
    state = PlayerState.defend;
  }

  bool get isOnGround => (y >= GameConfig.groundY - size.y - 0.5);

  @override
  void update(double dt) {
    super.update(dt);

    // Movement
    position += velocity * dt;

    // Gravity
    velocity.y += GameConfig.gravity * dt;
    if (position.y > GameConfig.groundY - size.y) {
      position.y = GameConfig.groundY - size.y;
      velocity.y = 0;
      if (state == PlayerState.jump) {
        state = PlayerState.idle;
      }
    }

    // Switch animations only when state changes
    if (_lastState != state && state != PlayerState.punch) {
      switch (state) {
        case PlayerState.idle:
          animation = idleAnimation;
          break;
        case PlayerState.walk:
          animation = walkAnimation;
          break;
        case PlayerState.run:
          animation = runAnimation;
          break;
        case PlayerState.jump:
          animation = jumpAnimation;
          break;
        case PlayerState.defend:
          animation = defendAnimation;
          break;
        default:
          break;
      }
      _lastState = state;
    }

    // Check punch animation completion
    if (_isPunching && animation!.loop) {
      _isPunching = false;
      state = PlayerState.idle;
    }

    // Flip if facing left
    scale.x = facingRight ? 1 : -1;
  }
}
