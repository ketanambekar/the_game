import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_game/game/game_controller.dart';

class GameHud extends StatelessWidget {
  const GameHud({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GameController>();

    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Active counts
          Obx(() => _counterBox(
            title: "Active Players",
            value: controller.activePlayerCount.value,
            color: Colors.blue,
          )),
          Obx(() => _counterBox(
            title: "Active Enemies",
            value: controller.activeEnemyCount.value,
            color: Colors.green,
          )),
          // Totals
          Obx(() => _counterBox(
            title: "Total Players",
            value: controller.totalPlayersSpawned.value,
            color: Colors.blueGrey,
          )),
          Obx(() => _counterBox(
            title: "Total Enemies",
            value: controller.totalEnemiesSpawned.value,
            color: Colors.teal,
          )),
        ],
      ),
    );
  }

  Widget _counterBox({required String title, required int value, required Color color}) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value.toString(),
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
