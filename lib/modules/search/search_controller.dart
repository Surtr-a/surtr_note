import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:surtr_note/data/local/local_data.dart';
import 'package:surtr_note/data/models/note.dart';
import 'package:surtr_note/utils/time.dart';

class SearchController extends GetxController {
  final LocalData _localData = Get.find<LocalData>();
  late final TextEditingController controller;
  List<Note> _noteList = [];
  var searchResult = <Note>[].obs;
  var isEmpty = true.obs;

  @override
  void onInit() {
    super.onInit();
    controller = TextEditingController();
    getList();
  }

  clean() {
    controller.text = '';
    searchResult.value = [];
  }

  getList() {
    var list = _localData.noteList;
    if (list != null) {
      _noteList = list;
    }
  }

  onChanged(String text) async {
    if (text.length != 0) {
      isEmpty.value = false;
    } else {
      isEmpty.value = true;
    }
    await Future.delayed(Duration(milliseconds: 500));
    _search(text);
  }

  _search(String text) {
    List<Note> result = [];
    _noteList.forEach((element) {
      if (element.title!.contains(text) ||
          element.content!.contains(text) ||
          TimeUtil.getSimpleDateStr(
                  DateTime.fromMillisecondsSinceEpoch(element.id!.toInt()))
              .contains(text) ||
          TimeUtil.getSimpleDateStr(DateTime.fromMicrosecondsSinceEpoch(
                  int.parse(element.dateTime!)))
              .contains(text)) {
        result.add(element);
      }
    });
    searchResult.value = result;
  }
}
