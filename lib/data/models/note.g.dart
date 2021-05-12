// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) {
  return Note()
    ..id = json['id'] as num?
    ..title = json['title'] as String?
    ..content = json['content'] as String?
    ..status = json['status'] as num?
    ..dateTime = json['dateTime'] as String?
    ..notification = json['notification'] as num?;
}

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'status': instance.status,
      'dateTime': instance.dateTime,
      'notification': instance.notification,
    };
