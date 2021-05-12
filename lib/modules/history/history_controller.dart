import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:surtr_note/data/local/local_data.dart';
import 'package:surtr_note/data/models/note.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class HistoryController extends GetxController {
  var localData = Get.find<LocalData>();
  bool isEditMode = false;
  bool isAllChecked = false;
  List<Note> noteList = [];
  List<bool> checked = [];

  @override
  void onReady() {
    super.onReady();
    getList();
  }

  deleteChecked() {
    checked.reversed.toList().asMap().forEach((key, value) {
      if (value == true) {
        noteList.removeAt(checked.length - key - 1);
      }
    });
    checked = List.filled(noteList.length, false);
    localData.updateNoteList(noteList);
    update();
  }

  Future<String?> exportChecked() async {
    final Workbook workbook = new Workbook();
    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('标题');
    sheet.getRangeByName('A1').cellStyle.backColor = '#F97B7B';
    sheet.getRangeByName('B1').setText('内容');
    sheet.getRangeByName('B1').columnWidth = 50;
    sheet.getRangeByName('B1').cellStyle.backColor = '#F97B7B';
    sheet.getRangeByName('C1').setText('创建时间');
    sheet.getRangeByName('C1').cellStyle.backColor = '#F97B7B';
    sheet.getRangeByName('D1').setText('最后修改时间');
    sheet.getRangeByName('D1').cellStyle.backColor = '#F97B7B';
    sheet.getRangeByName('E1').setText('状态');
    sheet.getRangeByName('E1').cellStyle.backColor = '#F97B7B';
    int line = 2;
    checked.asMap().forEach((key, value) {
      if (value == true) {
        sheet.getRangeByName('A$line').setText(noteList[key].title);
        sheet.getRangeByName('B$line').setText(noteList[key].content);
        sheet.getRangeByName('C$line').setDateTime(
            DateTime.fromMillisecondsSinceEpoch(
                noteList[key].id?.toInt() ?? 0));
        sheet.getRangeByName('D${key + 2}').setDateTime(
            DateTime.fromMicrosecondsSinceEpoch(
                int.parse(noteList[key].dateTime ?? '0')));
        sheet
            .getRangeByName('E${key + 2}')
            .setText(noteList[key].status == 0 ? '未完成' : '已完成');
        ++line;
      }
    });
    final List<int> bytes = workbook.saveAsStream();
    File? file;
    var temp = await getExternalStorageDirectory();
    if (temp != null) {
      var dir = Directory(temp.path + '/SurtrNote');
      if (!dir.existsSync()) {
        dir.createSync();
      }
      file = File(
          dir.path + '/surtr${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(bytes);
    }

    workbook.dispose();
    return file?.path;
  }

  changeEditMode() {
    if (isEditMode) {
      isEditMode = false;
      isAllChecked = true;
      turnAll();
      isAllChecked = false;
    } else
      isEditMode = true;
    update();
  }

  turnAll() {
    if (isAllChecked) {
      checked = checked.map((e) => false).toList();
      isAllChecked = false;
    } else {
      checked = checked.map((e) => true).toList();
      isAllChecked = true;
    }
    update();
  }

  reverse() {
    checked = checked.map((e) {
      if (e)
        return false;
      else
        return true;
    }).toList();
    update();
  }

  turn(int index) {
    if (checked[index]) {
      checked[index] = false;
    } else {
      checked[index] = true;
    }
    update();
  }

  getList() {
    var list = localData.noteList;
    if (list != null) {
      noteList = list;
      checked = List.filled(list.length, false);
      update();
    }
  }
}
