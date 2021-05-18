import 'dart:async';

import 'package:get/get.dart';
import 'package:surtr_note/data/models/note.dart';
import 'package:surtr_note/data/providers/database_service.dart';

class LocalData {
  static const String NOTE_LIST_KEY = 'note_list';
  static const String TEMP_NOTE_KEY = 'temp_note';
  late var _store = StoreRef.main();
  List<Note>? noteList;

  FutureOr operator [](key) async {
    return get(key);
  }

  void operator []=(key, value) {
    _put(value, key);
  }

  Future<T?> get<T>(dynamic key) async {
    final result = await _store.record(key).get(Get.find<Database>());
    if (result is T) {
      return result;
    }
    return null;
  }

  Future _put(dynamic key, dynamic value) async {
    return await _store.record(key).put(Get.find<Database>(), value);
  }

  Future _delete(dynamic key) async {
    return await _store.record(key).delete(Get.find<Database>());
  }

  Future<List<Note>?> getNoteList() async {
    final data = await get(NOTE_LIST_KEY);
    if (data == null) {
      noteList = [];
      return null;
    }
    noteList = (data as List).map((e) => Note.fromJson(e)).toList();
    return noteList;
  }

  Future updateNoteList(List<Note>? list) async {
    noteList = list;
    return await _put(NOTE_LIST_KEY, noteList?.map((e) => e.toJson()).toList());
  }

  Future addNote(Note note) async {
    if (noteList == null) await getNoteList();
    noteList!.insert(0, note);
    return await updateNoteList(noteList);
  }

  Future modifyNote(Note note) async {
    if (noteList == null) await getNoteList();
    Note old = noteList!.firstWhere((element) => element.id == note.id);
    noteList!.remove(old);
    noteList!.insert(0, note);
    await updateNoteList(noteList);
  }

  Future saveTempNote({Note? note}) async {
    if (note == null) {
      return await _delete(TEMP_NOTE_KEY);
    } else {
      return await _put(TEMP_NOTE_KEY, note.toJson());
    }
  }

  Future<Note?> getTempNote() async {
    var note = await get(TEMP_NOTE_KEY);
    return note != null ? Note.fromJson(note) : null;
  }
}
