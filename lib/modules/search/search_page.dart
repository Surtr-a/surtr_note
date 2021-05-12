import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:surtr_note/modules/search/search_controller.dart';
import 'package:surtr_note/routes/app_routes.dart';
import 'package:surtr_note/utils/utils.dart';

class SearchPage extends GetView<SearchController> {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: controller.controller,
          cursorColor: CustomColor.MPink,
          decoration: InputDecoration(
              hintText: '搜索笔记',
              border: InputBorder.none,
              suffixIcon: GetX<SearchController>(
                  builder: (_) => _.isEmpty.value
                      ? SizedBox.shrink()
                      : GestureDetector(
                          onTap: () => controller.clean(),
                          child: Icon(
                            Icons.close,
                            color: CustomColor.MPink,
                            size: 22,
                          )))),
          onChanged: controller.onChanged,
        ),
      ),
      body: _body,
    );
  }

  Widget get _body => GetX<SearchController>(
      builder: (_) => ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => Get.toNamed(Routes.DETAIL,
                    arguments: {'note': _.searchResult[index]}),
                child: ListTile(
                  title: Text.rich(
                    TextSpan(children: <TextSpan>[
                      if (_.searchResult[index].status == 0)
                        TextSpan(
                            text: '*',
                            style: TextStyle(color: CustomColor.MPink)),
                      TextSpan(text: _.searchResult[index].title!)
                    ]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    _.searchResult[index].content ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 1,
              indent: 4,
              endIndent: 4,
            ),
            itemCount: _.searchResult.length,
          ));
}
