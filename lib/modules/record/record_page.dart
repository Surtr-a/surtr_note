import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_note/modules/record/components/body.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: 'cancel');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Body(),
      ),
    );
  }
}
