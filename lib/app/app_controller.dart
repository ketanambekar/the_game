import 'package:get/get.dart';
import 'package:the_game/services/audio_service.dart';


class AppController extends GetxController {
  final audio = Get.find<AudioService>();


  double get musicVolume => audio.musicVolume;
  double get sfxVolume => audio.sfxVolume;


  void setMusic(double v) => audio.setMusicVolume(v);
  void setSfx(double v) => audio.setSfxVolume(v);
}