import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _isMusicMuted = false;
  bool _isSfxMuted = false;

  bool get isMusicMuted => _isMusicMuted;
  bool get isSfxMuted => _isSfxMuted;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isMusicMuted = prefs.getBool('musicMuted') ?? false;
    _isSfxMuted = prefs.getBool('sfxMuted') ?? false;

    _musicPlayer.setReleaseMode(ReleaseMode.loop);
    if (!_isMusicMuted) {
      playMusic('audio/background_music.mp3');
    }
  }

  Future<void> playMusic(String assetPath) async {
    if (!_isMusicMuted) {
      await _musicPlayer.play(AssetSource(assetPath));
    }
  }

  Future<void> stopMusic() async {
    await _musicPlayer.stop();
  }

  Future<void> playSfx(String assetPath) async {
    if (!_isSfxMuted) {
      final player = AudioPlayer();
      await player.play(AssetSource(assetPath));
    }
  }

  Future<void> toggleMusicMute(bool value) async {
    _isMusicMuted = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('musicMuted', value);

    if (value) {
      await stopMusic();
    } else {
      await playMusic('audio/background_music.mp3');
    }
  }

  Future<void> toggleSfxMute(bool value) async {
    _isSfxMuted = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sfxMuted', value);
  }
}
