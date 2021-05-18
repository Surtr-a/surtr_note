import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_note/data/local/local_data.dart';
import 'package:surtr_note/data/models/note.dart';
import 'package:surtr_note/material/confirm_dialog.dart';

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
    contentController =
        TextEditingController(text: note?.content ?? record?[0]);
  }

  @override
  void onReady() {
    super.onReady();
    getTemp();
  }

  Future getTemp() async {
    if (isEdit) return;
    var note = await Get.find<LocalData>().getTempNote();
    if (note != null) {
      Get.dialog(ConfirmDialog(
        content: '是否继续上次的创建？',
        okCallback: () {
          Get.back();
          titleController.text = note.title ?? '';
          contentController.text = note.content ?? '';
          addNotification(tempNotification: note.notification);
        },
      )).then((value) => Get.find<LocalData>().saveTempNote());
    }
  }

  Future saveTemp() async {
    if (note == null) {
      note = Note();
    }
    note!.title = titleController.text;
    note!.content = contentController.text;
    return await Get.find<LocalData>().saveTempNote(note: note!);
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

  void addNotification({DateTime? dateTime, num? tempNotification}) {
    if (note == null) {
      note = Note();
    }
    note?.notification = tempNotification ?? dateTime!.millisecondsSinceEpoch;
    update();
  }

  void deleteNotification() {
    note!.notification = null;
    update();
  }
}
