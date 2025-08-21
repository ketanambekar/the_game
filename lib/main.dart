import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_game/app/app.dart';
import 'package:the_game/services/audio_service.dart';
import 'package:the_game/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  Get.put(StorageService(), permanent: true);
  Get.put(AudioService(), permanent: true);
  runApp(const App());
}
