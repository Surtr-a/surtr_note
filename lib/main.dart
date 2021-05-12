import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:surtr_note/modules/home/home_binding.dart';
import 'package:surtr_note/modules/home/home_page.dart';
import 'package:surtr_note/routes/app_pages.dart';
import 'package:surtr_note/theme/app_theme.dart';
import 'package:surtr_note/utils/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化 Logger
  _initLogger();
  // 依赖注入
  await DependencyInjection.init();

  runApp(MyApp());
}

_initLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('[-->${record.loggerName}<--]: ${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Surtr Note',
        theme: appThemeData,
        getPages: AppPages.pages,
        home: HomePage(),
        initialBinding: HomeBinding(),
      ),
    );
  }
}