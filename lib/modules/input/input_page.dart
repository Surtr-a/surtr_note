import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_note/modules/input/components/body.dart';
import 'package:surtr_note/modules/input/input_controller.dart';
import 'package:surtr_note/routes/app_routes.dart';
import 'package:surtr_note/utils/utils.dart';
import 'package:surtr_note/material/confirm_dialog.dart';
import 'package:surtr_note/utils/extension/get_extension.dart';

class InputPage extends GetView<InputController> {
  const InputPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!controller.isEdit &&
            (controller.titleController.text.length != 0 ||
                controller.contentController.text.length != 0)) {
          controller.saveTemp();
        }
        return true;
      },
      child: Scaffold(
        appBar: _appBar(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var result =
                await Get.toNamed(Routes.RECORD, arguments: {'back': true});
            if (result != null) controller.contentController.text = result[0];
          },
          child: Icon(
            Icons.mic,
            color: Colors.white,
          ),
        ),
        body: Body(),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      actions: [
        GetBuilder<InputController>(
            builder: (_) => Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => controller.enable.value ||
                            controller.note?.notification != null
                        ? Get.dialog(_timeDialog,
                            barrierColor: Colors.black.withOpacity(.2))
                        : null,
                    child: Icon(
                      Icons.timer_outlined,
                      color: controller.note?.notification != null
                          ? CustomColor.MPink
                          : null,
                    ),
                  ),
                )),
        controller.isEdit
            ? GetX<InputController>(
                builder: (_) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                          onTap: () {
                            if (_.enable.value == true)
                              _.enable.value = false;
                            else
                              _.enable.value = true;
                          },
                          child: Icon(_.enable.value
                              ? Icons.edit_outlined
                              : Icons.edit)),
                    ))
            : SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                if (controller.isEdit &&
                    controller.note!.title == controller.titleController.text &&
                    controller.note!.content ==
                        controller.contentController.text &&
                    controller.hasTimer ==
                        (controller.note!.notification != null)) {
                  Get.back();
                } else {
                  var updated = await _showConfirmDialog;
                  if (updated != null && updated) {
                    Get.back(result: true);
                  }
                }
              },
              child: Icon(Icons.done)),
        )
      ],
    );
  }

  Widget get _timeDialog => Dialog(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: EdgeInsets.only(bottom: 8),
                  alignment: Alignment.center,
                  child: Text(
                    '定时任务',
                    style: TextStyleManager.grey_18_b
                        .copyWith(color: CustomColor.MPink),
                  )),
              controller.note?.notification == null
                  ? GestureDetector(
                      onTap: () async {
                        DateTime now = DateTime.now();
                        DateTime? date = await showDatePicker(
                            context: Get.context!,
                            initialDate: now,
                            firstDate: now,
                            lastDate: now.add(Duration(days: 365)));
                        TimeOfDay? time;
                        if (date != null) {
                          time = await showTimePicker(
                              context: Get.context!,
                              initialTime: TimeOfDay.now());
                        }
                        if (time != null) {
                          date = date!.add(
                              Duration(hours: time.hour, minutes: time.minute));
                          controller.addNotification(dateTime: date);
                        }
                        Get.back();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 120, vertical: 8),
                        color: CustomColor.MPink.withOpacity(.1),
                        child: Icon(
                          Icons.add,
                          color: CustomColor.MPink,
                          size: 32,
                        ),
                      ),
                    )
                  : Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      color: CustomColor.MPink.withOpacity(.1),
                      child: GetX<InputController>(builder: (_) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              TimeUtil.getSimpleDateStr(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      controller.note!.notification!.toInt())),
                              style: TextStyle(color: CustomColor.MPink),
                            ),
                            if (_.enable.value)
                              GestureDetector(
                                onTap: () {
                                  controller.deleteNotification();
                                  Get.back();
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )
                          ],
                        );
                      }),
                    )
            ],
          ),
        ),
      );

  Future get _showConfirmDialog {
    DateTime now = DateTime.now();
    String title = controller.titleController.text.length != 0
        ? controller.titleController.text
        : TimeUtil.getSimpleDateStr(now);
    return Get.dialog(ConfirmDialog(
        content: '${!controller.isEdit ? '新建' : '修改'}笔记\'$title\'？',
        okCallback: () async {
          Get.loading();
          if (controller.isEdit) {
            await controller.modify(title, now);
          } else {
            await controller.save(title, now);
          }
          Get.dismiss();
          Get.back(result: true);
        },
        cancelCallback: () {
          Get.back();
        }));
  }
}
