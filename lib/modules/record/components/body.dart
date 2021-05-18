import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:surtr_note/material/confirm_dialog.dart';
import 'package:surtr_note/modules/record/record_controller.dart';
import 'package:surtr_note/routes/app_routes.dart';
import 'package:surtr_note/utils/extension/get_extension.dart';
import 'package:surtr_note/utils/utils.dart';

class Body extends GetView<RecordController> {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment(0, .7),
          child: Ink(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: CustomColor.MPink),
            child: Listener(
              onPointerUp: (PointerUpEvent event) async {
                controller.tip.value = '按住说话';
                await controller.stopRecord();
                var result = await Get.dialog(ConfirmDialog(
                    content: '录音完成？',
                    okCallback: () async {
                      Get.loading();
                      List<String>? result = await controller.speechApi.speechRec(controller.filePath, 'wav');
                      Get.dismiss();
                      if (result != null) {
                        if (controller.back)
                          Get.back(result: result);
                        else {
                          var updated = await Get.toNamed(Routes.INPUT, arguments: {'record': result});
                          if (updated != null && updated == true)
                            Get.back(result: true);
                        }
                      }
                    }));
                if (result != null) {
                  Get.back(result: result);
                }
              },
              child: InkWell(
                onLongPress: () async {
                  controller.tip.value = '- 录音中，划出取消 -';
                  if (controller.recorderIsInited) {
                    controller.record();
                  }
                },
                onTapCancel: () {
                  controller.tip.value = '按住说话';
                  controller.stopRecord();
                },
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Icon(
                      Icons.mic,
                      size: 28,
                      color: Colors.white,
                    )),
              ),
            ),
          ),
        ),
        Align(
            alignment: Alignment(0, .4),
            child: Obx(() => Text(
              controller.tip.value,
              style: TextStyle(color: Colors.black45),
            ))),
        Align(
          alignment: Alignment(0, -.6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('阳和启蛰，品物皆春。', style: TextStyleManager.grey_15_i,),
              Text('Don\'t break my heart，再次温柔。', style: TextStyleManager.grey_15_i,),
              Text('人潮人海中，有你有我，相遇相识相互琢磨。', style: TextStyleManager.grey_15_i,),
            ],
          ),
        )
      ],
    );
  }
}
