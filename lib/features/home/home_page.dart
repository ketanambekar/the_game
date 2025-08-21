import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_game/app/app_controller.dart';
import 'package:the_game/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    final settings = Get.find<AppController>();
    return Scaffold(
      appBar: AppBar(title: const Text('LF Brawler')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.tonal(
                onPressed: () => Get.toNamed(AppRoutes.game),
                child: const Text('Start Game'),
              ),
              const SizedBox(height: 24),
              Obx(() => Column(
                children: [
                  Text('Music: ${settings.musicVolume.toStringAsFixed(2)}'),
                  Slider(
                    value: settings.musicVolume,
                    onChanged: settings.setMusic,
                  ),
                  const SizedBox(height: 8),
                  Text('SFX: ${settings.sfxVolume.toStringAsFixed(2)}'),
                  Slider(
                    value: settings.sfxVolume,
                    onChanged: settings.setSfx,
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}