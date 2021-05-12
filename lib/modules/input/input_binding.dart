import 'package:get/get.dart';
import 'package:surtr_note/data/local/local_data.dart';
import 'package:surtr_note/modules/input/input_controller.dart';

class InputBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocalData());
    Get.lazyPut(() => InputController());
  }
}