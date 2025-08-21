import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_game/core/game_config.dart';
import 'package:the_game/game/components/dummy_target.dart';
import 'package:the_game/game/components/ground.dart';
import 'package:the_game/game/components/player.dart';
import 'package:the_game/game/game_controller.dart';
import 'package:the_game/input/virtual_controls.dart';
import 'package:the_game/services/audio_service.dart';


class BrawlerGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  final List<Player> activePlayers = [];
  final List<DummyTarget> activeEnemies = [];

  int totalPlayersSpawned = 0;
  int totalEnemiesSpawned = 0;

  final Vector2 playerSpawn = Vector2(300, GameConfig.groundY - 120);
  final Vector2 enemySpawn = Vector2(600, GameConfig.groundY - 120);

  static const Duration playerRespawnDelay = Duration(seconds: 2);
  static const Duration enemyRespawnDelay = Duration(seconds: 3);
  double _spawnTimer = 0;
  final Random _rand = Random();
  int enemyCount = 0;

  GameController get gx => Get.find<GameController>();

  @override
  Color backgroundColor() => const Color(0xFF0B0B0B);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if (!Get.isRegistered<GameController>()) {
      Get.put(GameController(), permanent: true);
    }

    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: GameConfig.worldSize,
        paint: Paint()..color = const Color(0xFF101010),
      ),
    );

    add(Ground(
        size: Vector2(GameConfig.worldSize.x,
            GameConfig.worldSize.y - GameConfig.groundY)));

    // Spawn player
    spawnPlayer(position: playerSpawn);

    // Add virtual controls for mobile
    if (!children.whereType<VirtualControls>().isNotEmpty) {
      add(VirtualControls(getPrimaryPlayer()!));
    }
  }

  Player? getPrimaryPlayer() =>
      activePlayers.isNotEmpty ? activePlayers.first : null;

  Player spawnPlayer({Vector2? position}) {
    final pos = position ?? playerSpawn;
    final p = Player(position: pos);
    add(p);
    activePlayers.add(p);
    totalPlayersSpawned++;
    gx.playerSpawned(totalPlayersSpawned);
    gx.activePlayerCount.value = activePlayers.length;
    return p;
  }

  void spawnPlayerLater({Duration delay = playerRespawnDelay}) {
    Future.delayed(delay, () {
      spawnPlayer();
    });
  }

  void notifyEntityDead(PositionComponent entity) {
    if (entity is DummyTarget) {
      enemyCount = (enemyCount - 1).clamp(0, 999);
    }

    if (entity is Player) {
      activePlayers.remove(entity);
      gx.activePlayerCount.value = activePlayers.length;
      spawnPlayerLater();
    } else if (entity is DummyTarget) {
      activeEnemies.remove(entity);
      gx.activeEnemyCount.value = activeEnemies.length;
    }
  }

  void despawnEntity(PositionComponent entity) {
    entity.removeFromParent();
    notifyEntityDead(entity);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final primary = getPrimaryPlayer();
    if (primary != null && children.contains(primary)) {
      final viewW = size.x;
      final targetX =
      (primary.position.x - viewW / 2).clamp(0, GameConfig.worldSize.x - viewW);
      camera.viewfinder.position = Vector2(targetX.toDouble(), 0);
    }

    final controls = children.whereType<VirtualControls>().toList();
    if (controls.isNotEmpty && primary != null) {
      controls.first.player = primary;
    }
  }

  // 🔑 Keyboard control support (PC/Web testing)
  @override
  KeyEventResult onKeyEvent(
      KeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    // Move left/right
    final player = getPrimaryPlayer();
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      player?.moveLeft(run: keysPressed.contains(LogicalKeyboardKey.shiftLeft));
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      player!.moveRight(run: keysPressed.contains(LogicalKeyboardKey.shiftLeft));
    } else {
      player!.stopMoving();
    }

    // Jump
    if (keysPressed.contains(LogicalKeyboardKey.space)) {
      player!.jump();
    }

    // Attack
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      player!.punch();
    }

    // Defend
    if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      player!.defend();
    }

    return KeyEventResult.handled;
  }
}
