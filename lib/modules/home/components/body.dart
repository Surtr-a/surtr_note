import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:surtr_note/material/confirm_dialog.dart';
import 'package:surtr_note/material/custom_scroll_behavior.dart';
import 'package:surtr_note/modules/home/home_controller.dart';
import 'package:surtr_note/routes/app_routes.dart';
import 'package:surtr_note/utils/utils.dart';

class Body extends GetView<HomeController> {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        builder: (_) => ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: SmartRefresher(
                controller: controller.refreshController,
                onRefresh: controller.onRefresh,
                header: MaterialClassicHeader(
                  color: CustomColor.MPink,
                ),
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) => Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Slidable(
                        controller: controller.slidableController,
                        actionPane: SlidableScrollActionPane(),
                        actionExtentRatio: 0.2,
                        child: GestureDetector(
                          onTap: () async {
                            controller.slidableController.activeState?.close();
                            var result = await Get.toNamed(Routes.INPUT,
                                arguments: {'note': controller.notes[index]});
                            if (result != null && result == true) {
                              controller.getList();
                            }
                          },
                          onLongPress: () => showDeleteDialog(index),
                          child: ListTile(
                            title: Text(
                              controller.notes[index].title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    controller.notes[index].content ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  TimeUtil.getTimeIntervalStr(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          int.parse(controller
                                                  .notes[index].dateTime ??
                                              '0'))),
                                  style: TextStyleManager.grey_14_i,
                                )
                              ],
                            ),
                            trailing: Container(
                              width: 2,
                              height: 32,
                              color: controller.timeoutId.contains(controller.notes[index].id)
                                  ? Colors.red
                                  : controller.willTimeoutId.contains(controller.notes[index].id)
                                      ? Colors.orange.withOpacity(.4)
                                      : null,
                            ),
                          ),
                        ),
                        secondaryActions: [
                          SlideAction(
                            onTap: () => showDeleteDialog(index),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13),
                                )
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4),
                                bottomRight: Radius.circular(4)),
                            child: SlideAction(
                              onTap: () => controller.finish(index),
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  Text(
                                    'finished',
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 13),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                  itemCount: controller.notes.length,
                ),
              ),
            ));
  }

  void showDeleteDialog(int index) {
    Get.dialog(ConfirmDialog(
        content: '删除\'${controller.notes[index].title}\'？',
        okCallback: () async {
          await controller.deleteNote(index);
          Get.back();
        },
        cancelCallback: () {
          Get.back();
        }));
  }
}
