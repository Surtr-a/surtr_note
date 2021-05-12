import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_note/utils/text_style.dart';

class ConfirmDialog extends StatelessWidget {
  final String content;
  final VoidCallback okCallback;
  final VoidCallback? cancelCallback;

  const ConfirmDialog(
      {Key? key,
      required this.content,
      required this.okCallback,
      this.cancelCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'SurtrNote',
        style: TextStyleManager.grey_18_b,
      ),
      content: Text(content),
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      actionsPadding: EdgeInsets.zero,
      actions: [
        TextButton(
            onPressed: cancelCallback ?? () {Get.back();},
            child: Text(
              'CANCEL',
              style: TextStyleManager.m_13,
            )),
        TextButton(
            onPressed: okCallback,
            child: Text(
              'OK',
              style: TextStyleManager.m_13,
            )),
      ],
    );
  }
}
