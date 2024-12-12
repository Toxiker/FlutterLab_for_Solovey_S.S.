import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'notesModel.dart';

class NotesFileWorker {
  static final NotesFileWorker instance = NotesFileWorker._();
  NotesFileWorker._();

  Future<List<Note>> getNotes(int categoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('notes') ?? '[]';
      final notes = List<Map<String, dynamic>>.from(jsonDecode(data))
          .map((e) => Note.fromMap(e))
          .toList();
      return notes.where((note) => note.categoryId == categoryId).toList();
    } catch (e) {
      print("Ошибка чтения заметок: $e");
      return [];
    }
  }

  Future<void> saveNotes(List<Note> notes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = notes.map((note) => note.toMap()).toList();
      await prefs.setString('notes', jsonEncode(data));
    } catch (e) {
      print("Ошибка записи заметок: $e");
    }
  }
}
