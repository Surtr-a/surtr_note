import 'package:get/get.dart';
import 'package:surtr_note/data/api/speech_api.dart';
import 'package:surtr_note/modules/record/record_controller.dart';

class RecordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SpeechApi());
    Get.put(RecordController());
  }
}