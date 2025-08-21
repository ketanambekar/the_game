import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_game/game/brawler_game.dart';
import 'package:the_game/game/game_controller.dart';
import 'package:the_game/game/ui/game_hud.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(GameController());

    final game = BrawlerGame();

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game),
          const GameHud(),
        ],
      ),
    );
  }
}
