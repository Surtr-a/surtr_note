import 'package:get/get.dart';
import 'package:surtr_note/data/local/local_data.dart';
import 'package:surtr_note/modules/search/search_controller.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LocalData());
    Get.put(SearchController());
  }
}