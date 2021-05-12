import 'package:get/get.dart';
import 'package:surtr_note/data/providers/app_sp_service.dart';
import 'package:surtr_note/data/providers/database_service.dart';
import 'package:surtr_note/data/providers/dio_config_service.dart';
import 'package:surtr_note/data/remote/dio_client.dart';

class DependencyInjection {
  static Future<void> init() async {
    // SharedPreference
    await Get.putAsync(() => AppSpService().init());
    // dio配置信息
    await Get.putAsync(() => DioConfigController().init());
    //  网络请求
    Get.put(DioClient());
    // Database
    await Get.putAsync(() => DatabaseService().init());
  }
}