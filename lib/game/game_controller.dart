import 'package:get/get.dart';

class GameController extends GetxController {
  var playerHealth = 100.obs;
  var enemyHealth = 100.obs;
  final totalPlayersSpawned = 0.obs;
  final totalEnemiesSpawned = 0.obs;
  final activePlayerCount = 0.obs;
  final activeEnemyCount = 0.obs;
  var isPaused = false.obs;
  var score = 0.obs;

  void damagePlayer(int dmg) {
    playerHealth.value = (playerHealth.value - dmg).clamp(0, 100);
  }

  void damageEnemy(int dmg) {
    enemyHealth.value = (enemyHealth.value - dmg).clamp(0, 100);
  }

  void resetGame() {
    playerHealth.value = 100;
    enemyHealth.value = 100;
    score.value = 0;
    isPaused.value = false;
  }

  void playerSpawned(int total) {
    totalPlayersSpawned.value = total;
  }

  void enemySpawned(int total) {
    totalEnemiesSpawned.value = total;
  }
}
