import 'package:get/get.dart';
import 'package:surtr_note/data/local/local_data.dart';
import 'package:surtr_note/modules/history/history_controller.dart';

class HistoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LocalData());
    Get.put(HistoryController());
  }
}