import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:surtr_note/material/confirm_dialog.dart';
import 'package:surtr_note/modules/history/history_controller.dart';
import 'package:surtr_note/routes/app_routes.dart';
import 'package:surtr_note/utils/utils.dart';
import 'package:surtr_note/utils/extension/get_extension.dart';

final Logger _log = Logger('HistoryPage');

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
        builder: (_) => WillPopScope(
              onWillPop: () async {
                if (controller.isEditMode) {
                  controller.changeEditMode();
                  return false;
                } else {
                  return true;
                }
              },
              child: Scaffold(
                floatingActionButton: _floatingActionButtons,
                appBar: AppBar(
                  actions: controller.isEditMode
                      ? [
                          GestureDetector(
                              onTap: () => controller.reverse(),
                              child:
                                  Icon(Icons.indeterminate_check_box_outlined)),
                          SizedBox(
                            width: 16,
                          ),
                          GetBuilder<HistoryController>(
                            builder: (_) => GestureDetector(
                                onTap: () => controller.turnAll(),
                                child: Icon(controller.isAllChecked
                                    ? Icons.fact_check
                                    : Icons.fact_check_outlined)),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                        ]
                      : [
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.SEARCH),
                            child: Icon(Icons.search),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: GestureDetector(
                                  onTap: () => controller.changeEditMode(),
                                  child: Icon(Icons.edit_outlined)))
                        ],
                ),
                body: _body,
              ),
            ));
  }

  Widget get _body => ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: GestureDetector(
                onTap: !controller.isEditMode
                    ? () {
                        Get.toNamed(Routes.DETAIL,
                            arguments: {'note': controller.noteList[index]});
                      }
                    : null,
                onLongPress: () {
                  if (!controller.isEditMode) {
                    controller.changeEditMode();
                    controller.turn(index);
                  }
                },
                child: ListTile(
                  title: Text.rich(
                    TextSpan(children: <TextSpan>[
                      if (controller.noteList[index].status == 0)
                        TextSpan(
                            text: '*',
                            style: TextStyle(color: CustomColor.MPink)),
                      TextSpan(text: controller.noteList[index].title!)
                    ]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    controller.noteList[index].content ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: controller.isEditMode
                      ? Checkbox(
                          fillColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (!states.contains(MaterialState.selected)) {
                              return Colors.black26;
                            }
                          }),
                          value: controller.checked[index],
                          onChanged: (checked) {
                            controller.turn(index);
                          })
                      : null,
                ),
              ));
        },
        itemCount: controller.noteList.length,
      );

  Widget? get _floatingActionButtons => controller.isEditMode
      ? Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () {
                  Get.dialog(ConfirmDialog(
                      content: '确定删除选中？',
                      okCallback: () {
                        controller.deleteChecked();
                        controller.changeEditMode();
                        Get.back();
                      }));
                },
                backgroundColor: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 12,
              ),
              FloatingActionButton(
                onPressed: () async {
                  Get.loading();
                  String? fileName = await controller.exportChecked();
                  Get.dismiss();
                  if (fileName != null) {
                    _log.fine('export excel file: $fileName');
                    toast('文件已导出：$fileName');
                  }
                },
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.next_week,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      : null;
}
