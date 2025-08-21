import 'package:flame_audio/flame_audio.dart';
import 'package:get/get.dart';
import 'package:the_game/services/storage_service.dart';


class AudioService extends GetxService {
  final _musicVolume = 0.6.obs;
  final _sfxVolume = 0.8.obs;


// keep track of the currently playing BGM filename (if any)
  String? _currentBgm;


  double get musicVolume => _musicVolume.value;
  double get sfxVolume => _sfxVolume.value;


  @override
  void onInit() {
    super.onInit();
// Initialize the bgm manager (requires WidgetsBinding - ensureInitialized()
// was called in main). It's safe to call here.
    FlameAudio.bgm.initialize();


    final storage = Get.find<StorageService>();
    _musicVolume.value = storage.readDouble(StorageKeys.musicVolume, 0.6);
    _sfxVolume.value = storage.readDouble(StorageKeys.sfxVolume, 0.8);
  }


  /// Set music volume.
  ///
  /// Note: `flame_audio`'s Bgm class does **not** expose a `setVolume` API.
  /// To update the BGM volume we restart the currently playing track with the
  /// new volume (the Bgm.play method accepts an optional `volume` parameter).
  void setMusicVolume(double v) {
    _musicVolume.value = v;
    Get.find<StorageService>().writeDouble(StorageKeys.musicVolume, v);


    if (_currentBgm != null) {
// Restart the current bgm with the new volume. This will reset the
// playback position to the beginning; that's the simplest cross-platform
// approach with the current flame_audio API. If you want to change
// volume without restarting, we'd need to access the underlying
// AudioPlayer instance directly (more involved).
      FlameAudio.bgm.stop();
      FlameAudio.bgm.play(_currentBgm!, volume: v);
    }
  }


  void setSfxVolume(double v) {
    _sfxVolume.value = v;
    Get.find<StorageService>().writeDouble(StorageKeys.sfxVolume, v);
  }


  /// Play a looping/background music track (managed by Bgm).
  Future<void> playBgm(String file, {double? volume}) async {
    _currentBgm = file;
    await FlameAudio.bgm.play(file, volume: volume ?? musicVolume);
  }


  /// Stop background music (and clear current track).
  void stopBgm() {
    _currentBgm = null;
    FlameAudio.bgm.stop();
  }


  Future<void> sfx(String file, {double? volume}) async {
    await FlameAudio.play(file, volume: volume ?? sfxVolume);
  }


  @override
  void onClose() {
    FlameAudio.bgm.dispose();
    super.onClose();
  }
}