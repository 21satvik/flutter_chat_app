import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

class SoundPlayer {
  FlutterSoundPlayer? _audioPlayer;

  Future init() async {
    _audioPlayer = FlutterSoundPlayer();

    await _audioPlayer!.openAudioSession();
  }

  Future _play(VoidCallback whenFinished, String url) async {
    await _audioPlayer!.startPlayer(
      fromURI: url,
      codec: Codec.pcm16WAV,
      whenFinished: whenFinished,
    );
  }

  void dispose() {
    _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
  }

  Future _stop() async {
    await _audioPlayer!.stopPlayer();
  }

  Future togglePlaying(VoidCallback whenFinished, String url) async {
    if (_audioPlayer!.isPlaying) {
      await _stop();
    } else {
      await _play(whenFinished, url);
    }
  }
}
