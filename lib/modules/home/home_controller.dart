import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:surtr_note/data/local/local_data.dart';
import 'package:surtr_note/data/models/note.dart';

class HomeController extends GetxController {
  List<Note> source = [];
  List<Note> notes = [];
  List<int> timeoutId = [];
  List<int> willTimeoutId = [];
  final localData = Get.find<LocalData>();
  late final RefreshController refreshController;
  late final SlidableController slidableController;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(initialRefresh: false);
    slidableController = SlidableController();
  }

  @override
  void onReady() {
    super.onReady();
    getList().then((value) {
      String? tip = _getTips();
      if (tip != null) {
        toast(tip, duration: Toast.LENGTH_LONG);
      }
    });
  }

  Future getList() async {
    var list = await localData.getNoteList();
    if (list != null) {
      source = list;
      notes = source.where((value) => value.status == 0).toList();
      _checkTimer();
      update();
    }
  }

  String? _checkTimer() {
    DateTime now = DateTime.now();
    notes.forEach((element) {
      int? target = element.notification?.toInt();
      if (target != null) {
        if (target <= now.millisecondsSinceEpoch) {
          timeoutId.add(element.id!.toInt());
        } else if ((target - now.millisecondsSinceEpoch) <
            Duration(minutes: 10).inMilliseconds) {
          willTimeoutId.add(element.id!.toInt());
        }
      }
    });
  }
  
  String? _getTips() {
    String tip = '您有';
    if (timeoutId.length != 0) {
      tip += '${timeoutId.length}个任务已过期';
      if (willTimeoutId.length != 0) {
        tip += '，';
      }
    }
    if (willTimeoutId.length != 0) {
      tip += '${willTimeoutId.length}个任务即将过期';
    }
    if (tip != '您有') {
      tip += '。';
      return tip;
    }
    return null;
  }

  Future finish(int index) async {
    Note note = notes[index];
    source[source.indexOf(note)].status = 1;
    await localData.updateNoteList(source);
    notes.removeAt(index);
    update();
  }

  Future deleteNote(int index) async {
    source.remove(notes[index]);
    notes.removeAt(index);
    await localData.updateNoteList(source);
    update();
  }

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    await getList();
    toast('刷新成功');
    refreshController.refreshCompleted();
  }
}
