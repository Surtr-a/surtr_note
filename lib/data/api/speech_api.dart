import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surtr_note/data/config.dart';
import 'package:surtr_note/data/remote/app_response.dart';
import 'package:surtr_note/data/remote/dio_client.dart';
import 'package:surtr_note/data/models/speech_recognition_req.dart';

class SpeechApi {
  static const String BAIDU_AUTH_URL = 'https://aip.baidubce.com/oauth/2.0/token';
  static const String SPEECH_REC_URL = '/server_api';
  final DioClient _dio = getx.Get.find<DioClient>();

  Future<List<String>?> speechRec(String filePath, String format) async {
    SpeechRecognitionReq request = SpeechRecognitionReq();
    String? token = getx.Get.find<SharedPreferences>().getString(
        Config.BAIDU_TOKEN_SP_KEY) ?? await getToken();
    if (token == null) return null;
    getx.Get.find<SharedPreferences>().setString(Config.BAIDU_TOKEN_SP_KEY, token);
    request.token = token;
    request.rate = 16000;
    request.channel = 1;
    request.dev_pid = 1537;
    request.cuid = 'NMGPvsugB65cGo6QLIuSrqefSurtr';
    request.format = format;
    var byte = File(filePath).readAsBytesSync();
    String recordStr = base64Encode(byte);
    request.speech = recordStr;
    request.len = byte.length;
    AppResponse resp = await _dio.post(SPEECH_REC_URL, data: request);
    if (resp.ok) {
      return (resp.data['result'] as List<dynamic>).cast<String>();
    } else {
      if (resp.error.code == 3302) {
        String? token = await getToken();
        if (token != null) {
          getx.Get.find<SharedPreferences>().setString(Config.BAIDU_TOKEN_SP_KEY, token);
        }
      }
      return null;
    }
  }

  Future<String?> getToken() async {
    String url = '$BAIDU_AUTH_URL'
        '?grant_type=client_credentials'
        '&client_id=${Config.CLIENT_ID}'
        '&client_secret=${Config.CLIENT_SECRET}';
    Dio dio = Dio();
    Response resp = await dio.get(url);
    return resp.statusCode == 200 ? resp.data['access_token'] : null;
  }
}