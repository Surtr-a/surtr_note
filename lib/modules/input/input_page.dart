import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_note/modules/input/components/body.dart';
import 'package:surtr_note/modules/input/input_controller.dart';
import 'package:surtr_note/routes/app_routes.dart';
import 'package:surtr_note/utils/time.dart';
import 'package:surtr_note/material/confirm_dialog.dart';
import 'package:surtr_note/utils/extension/get_extension.dart';

class InputPage extends GetView<InputController> {
  const InputPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Get.toNamed(Routes.RECORD, arguments: {'back': true});
          if (result != null)
            controller.contentController.text = result[0];
        },
        child: Icon(
          Icons.mic,
          color: Colors.white,
        ),
      ),
      body: Body(),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      actions: [
        GetBuilder<InputController>(builder: (_) {
          return Icon(Icons.timer_outlined);
        }),
        controller.note != null
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
                if (controller.note != null &&
                    controller.note!.title == controller.titleController.text &&
                    controller.note!.content ==
                        controller.contentController.text) {
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

  Future get _showConfirmDialog {
    DateTime now = DateTime.now();
    String title = controller.titleController.text.length != 0
        ? controller.titleController.text
        : TimeUtil.getSimpleDateStr(now);
    return Get.dialog(ConfirmDialog(
        content: '${controller.note == null ? '新建' : '修改'}笔记\'$title\'？',
        okCallback: () async {
          Get.loading();
          if (controller.note == null) {
            await controller.save(title, now);
          } else {
            await controller.modify(title, now);
          }
          Get.dismiss();
          Get.back(result: true);
        },
        cancelCallback: () {
          Get.back();
        }));
  }
}
