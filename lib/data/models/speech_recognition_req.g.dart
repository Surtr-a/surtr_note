// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_recognition_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpeechRecognitionReq _$SpeechRecognitionReqFromJson(Map<String, dynamic> json) {
  return SpeechRecognitionReq()
    ..format = json['format'] as String?
    ..rate = json['rate'] as num?
    ..dev_pid = json['dev_pid'] as num?
    ..channel = json['channel'] as num?
    ..token = json['token'] as String?
    ..cuid = json['cuid'] as String?
    ..len = json['len'] as num?
    ..speech = json['speech'] as String?;
}

Map<String, dynamic> _$SpeechRecognitionReqToJson(
        SpeechRecognitionReq instance) =>
    <String, dynamic>{
      'format': instance.format,
      'rate': instance.rate,
      'dev_pid': instance.dev_pid,
      'channel': instance.channel,
      'token': instance.token,
      'cuid': instance.cuid,
      'len': instance.len,
      'speech': instance.speech,
    };
