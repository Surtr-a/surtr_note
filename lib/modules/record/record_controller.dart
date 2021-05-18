import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:surtr_note/data/api/speech_api.dart';

class RecordController extends GetxController {
  SpeechApi speechApi = Get.find<SpeechApi>();
  late FlutterSoundRecorder _myRecorder;
  bool recorderIsInited = false;
  bool back = Get.arguments?['back'] ?? false;
  late String filePath;
  var tip = '按住说话'.obs;

  @override
  void onInit() async {
    super.onInit();
    filePath = (await getTemporaryDirectory()).path + '/record/temp.wav';
    _myRecorder = FlutterSoundRecorder();
    _myRecorder.openAudioSession().then((value) {
      recorderIsInited = true;
    });
  }

  @override
  void onReady() {
    super.onReady();
    permissionCheck();
  }

  Future<void> permissionCheck() async {
    if (await Permission.microphone.status.isDenied || await Permission.storage.status.isDenied) {
      var micStatus = await Permission.microphone.request();
      var storageStatus = await Permission.storage.request();
      if (!micStatus.isGranted || !storageStatus.isGranted) {
        Get.back();
      }
    }
  }

  @override
  void onClose() {
    _myRecorder.closeAudioSession();
    super.onClose();
  }

  Future<void> record() async {
    Directory dir = Directory(path.dirname(filePath));
    if (!dir.existsSync()) {
      dir.createSync();
    }
    await _myRecorder.startRecorder(
      toFile: filePath,
      codec: Codec.pcm16WAV,
    );
  }

  Future<String?> stopRecord() async {
    return await _myRecorder.stopRecorder();
  }
}