import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:the_game/core/game_config.dart';
import 'package:the_game/game/brawler_game.dart';
import 'package:the_game/game/components/attack_hitbox.dart';
import 'package:the_game/game/components/health_bar.dart';
import 'player.dart';

class DummyTarget extends PositionComponent
    with CollisionCallbacks, HasGameRef<BrawlerGame> {
  double maxHp = 100;
  double currentHp = 100;
  late HealthBar hpBar;

  // Movement
  final velocity = Vector2.zero();
  bool facingRight = true;
  double speed = 140; // faster for more aggression

  // Attack cooldown
  double _attackTimer = 0;

  DummyTarget({required Vector2 position}) {
    this.position = position;
    size = Vector2(80, 120);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    hpBar = HealthBar(maxHp: maxHp, currentHp: currentHp, barWidth: 40);
    hpBar.position = Vector2(0, -12);
    add(hpBar);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Always try to find nearest player
    final player = _findNearestPlayer();
    if (player == null || !player.isMounted) {
      velocity.x = 0;
      return;
    }

    _attackTimer -= dt;

    final dx = player.x - x;
    final distance = dx.abs();

    // --- Movement / Chasing ---
    if (distance > 70) { // closer threshold before stopping
      velocity.x = dx > 0 ? speed : -speed;
      facingRight = dx > 0;
    } else {
      velocity.x = 0; // close enough to attack
    }

    // --- Jump if player is above ---
    if (player.y + 20 < y && isOnGround) {
      velocity.y = -GameConfig.jumpSpeed * 0.9; // jump slightly higher
    }

    // Gravity
    velocity.y += GameConfig.gravity * dt;

    // --- Attacking ---
    if (distance < 140 && _attackTimer <= 0 && isOnGround) {
      _attackTimer = 1.0; // shorter cooldown = more aggressive
      _lightAttack();
    }

    // Integrate position
    position += velocity * dt;

    // Clamp to ground
    final groundY = GameConfig.groundY - size.y;
    if (position.y > groundY) {
      position.y = groundY;
      velocity.y = 0;
    }
  }

  bool get isOnGround =>
      (position.y - (GameConfig.groundY - size.y)).abs() < 0.5;

  void _lightAttack() {
    final hitW = 70.0; // slightly wider hitbox
    final hitH = 30.0;
    final offsetX = facingRight ? size.x / 2 : -size.x / 2 - hitW;
    final localPos = Vector2(offsetX, size.y * 0.2);

    final hit = AttackHitbox(
      offset: localPos,
      size: Vector2(hitW, hitH),
      damage: 12, // harder hits
      owner: this,
    );
    add(hit);

    Future.delayed(const Duration(milliseconds: 150), () {
      hit.removeFromParent();
    });
  }

  void takeHit(double dmg) {
    currentHp -= dmg;
    hpBar.updateHp(currentHp);

    if (currentHp <= 0) {
      gameRef.notifyEntityDead(this);
      removeFromParent();
    }
  }

  Player? _findNearestPlayer() {
    final players = gameRef.children.whereType<Player>().toList();
    if (players.isEmpty) return null;

    players.sort((a, b) =>
        (a.position - position).length.compareTo((b.position - position).length));

    return players.first;
  }

  @override
  void render(Canvas canvas) {
    final r = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(8));
    final paint = Paint()..color = Colors.redAccent;
    canvas.save();
    if (!facingRight) {
      canvas.translate(size.x, 0);
      canvas.scale(-1, 1);
    }
    canvas.drawRRect(r, paint);
    canvas.restore();
  }
}
