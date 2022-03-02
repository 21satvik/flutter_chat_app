import 'dart:io';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  FlutterSoundRecorder? _recorder;
  bool _isRecorderInitialised = false;
  String path = '';

  Future init() async {
    _recorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print('Permission to use microphone denied');
      return;
    }

    await _recorder!.openAudioSession();
    _isRecorderInitialised = true;
  }

  void dispose() {
    if (!_isRecorderInitialised) return;

    _recorder!.closeAudioSession();
    _recorder = null;
    _isRecorderInitialised = true;
  }

  Future record() async {
    if (!_isRecorderInitialised) return;
    Directory temp = await getTemporaryDirectory();
    path = '${temp.path}/recording.wav';
    print(path);

    await _recorder!.startRecorder(toFile: path, codec: Codec.pcm16WAV);
  }

  Future stop() async {
    if (!_isRecorderInitialised) return;

    await _recorder!.stopRecorder();
  }

  String get filePath {
    return path;
  }
}
