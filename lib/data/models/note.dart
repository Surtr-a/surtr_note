import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  Note();

	num? id;
	String? title;
	String? content;
	num? status;
	String? dateTime;
	num? notification;


  factory Note.fromJson(Map<String,dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}