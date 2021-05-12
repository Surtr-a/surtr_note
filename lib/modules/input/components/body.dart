import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_note/modules/input/input_controller.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GetX<InputController>(
          builder: (controller) => Column(
                children: [
                  TextField(
                    enabled: controller.enable.value,
                    controller: controller.titleController,
                    decoration: InputDecoration(hintText: 'Create Note'),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Expanded(
                      child: TextField(
                        enabled: controller.enable.value,
                    maxLines: 99,
                    controller: controller.contentController,
                  ))
                ],
              )),
    );
  }
}
