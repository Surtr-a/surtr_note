import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:surtr_note/data/local/local_data.dart';
import 'package:surtr_note/data/models/note.dart';

class HomeController extends GetxController {
  List<Note> source = [];
  List<Note> notes = [];
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
    getList();
  }

  Future getList() async {
    var list = await localData.getNoteList();
    if (list != null) {
      source = list;
      notes = source.where((value) => value.status == 0).toList();
      update();
    }
  }

  String? checkTimer() {
    int timeoutCount = 0;
    int willTimeoutCount = 0;
    DateTime now = DateTime.now();
    notes.forEach((element) {
      int? target = element.notification?.toInt();
      if (target != null) {
        if (target <= now.millisecondsSinceEpoch) {
          ++timeoutCount;
        } else if ((target - now.millisecondsSinceEpoch) <
            Duration(minutes: 10).inMilliseconds) {
          ++willTimeoutCount;
        }
      }
    });
    String tip = '您有';
    if (timeoutCount != 0) {
      tip += '$timeoutCount个任务已过期';
      if (willTimeoutCount != 0) {
        tip += '，';
      }
    }
    if (willTimeoutCount != 0) {
      tip += '$willTimeoutCount个任务即将过期';
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
    refreshController.refreshCompleted();
  }
}
