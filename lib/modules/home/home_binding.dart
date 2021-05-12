import 'package:get/get.dart';
import 'package:surtr_note/data/local/local_data.dart';
import 'package:surtr_note/modules/home/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LocalData());
    Get.put(HomeController());
  }
}