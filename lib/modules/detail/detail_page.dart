import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:surtr_note/data/models/note.dart';
import 'package:surtr_note/utils/text_style.dart';
import 'package:surtr_note/utils/time.dart';

class DetailPage extends StatelessWidget {
  DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body,
    );
  }

  Widget get _body {
    final Note note = Get.arguments?['note'] ?? Note();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Title: ',
                  style: TextStyleManager.grey_14_i,
                ),
                Text(note.title ?? '', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8,),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                'Create at: ${TimeUtil.getSimpleDateStr(DateTime.fromMillisecondsSinceEpoch(note.id?.toInt() ?? 0))}',
                style: TextStyleManager.grey_14_i,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                'Last modify: ${TimeUtil.getSimpleDateStr(DateTime.fromMicrosecondsSinceEpoch(int.parse(note.dateTime ?? '0')))}',
                style: TextStyleManager.grey_14_i,
              ),
            ),
            Divider(
              height: 12,
            ),
            Text(
              'Content: ',
              style: TextStyleManager.grey_14_i,
            ),
            Text(note.content ?? ''),
          ],
        ),
      ),
    );
  }
}
