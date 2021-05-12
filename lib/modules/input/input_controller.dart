import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_note/data/local/local_data.dart';
import 'package:surtr_note/data/models/note.dart';

class InputController extends GetxController {
  Note? note = Get.arguments?['note'];
  List<String>? record = Get.arguments?['record'];
  var enable = (Get.arguments?['note'] == null ? true : false).obs;
  bool isEdit = Get.arguments?['note'] == null ? false : true;
  late bool hasTimer;
  late TextEditingController titleController;
  late TextEditingController contentController;


  @override
  void onInit() {
    super.onInit();
    hasTimer = note?.notification != null;
    titleController = TextEditingController(text: note?.title);
    contentController = TextEditingController(text: note?.content ?? record?[0]);
  }

  Future<void> save(String title, DateTime timeStamp) async {
    if (note == null) {
      note = Note();
    }
    note!.id = timeStamp.millisecondsSinceEpoch;
    note!.title = title;
    note!.status = 0;
    note!.dateTime = timeStamp.microsecondsSinceEpoch.toString();
    note!.content = contentController.text;
    await Get.find<LocalData>().addNote(note!);
  }

  Future<void> modify(String title, DateTime timeStamp) async {
    note!.title = title;
    note!.content = contentController.text;
    note!.dateTime = timeStamp.microsecondsSinceEpoch.toString();
    await Get.find<LocalData>().modifyNote(note!);
  }

  void addNotification(DateTime dateTime) {
    if (note == null) {
      note = Note();
    }
    note?.notification = dateTime.millisecondsSinceEpoch;
    update();
  }

  void deleteNotification() {
    note!.notification = null;
    update();
  }
}