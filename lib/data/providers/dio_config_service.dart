import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:surtr_note/data/remote/dio_config.dart';

class DioConfigController extends GetxService {
  Future<DioConfig> init() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String cookiesPath = join(appDocDir.path, ".cookies/");
    DioConfig dioConfig = DioConfig();
    dioConfig.init('http://vop.baidu.com', cookiesPath: cookiesPath);
    return dioConfig;
  }
}