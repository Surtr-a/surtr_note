import 'package:json_annotation/json_annotation.dart';

part 'speech_recognition_req.g.dart';

@JsonSerializable()
class SpeechRecognitionReq {
  SpeechRecognitionReq();

	String? format;
	num? rate;
	num? dev_pid;
	num? channel;
	String? token;
	String? cuid;
	num? len;
	String? speech;


  factory SpeechRecognitionReq.fromJson(Map<String,dynamic> json) => _$SpeechRecognitionReqFromJson(json);
  Map<String, dynamic> toJson() => _$SpeechRecognitionReqToJson(this);
}