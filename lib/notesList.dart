import 'package:flutter/material.dart';
import 'notesFileWorker.dart';
import 'notesModel.dart';
import 'notesEntry.dart';

class NotesList extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  NotesList({required this.categoryId, required this.categoryName});

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final notes = await NotesFileWorker.instance.getNotes(widget.categoryId);
      setState(() {
        _notes = notes;
      });
    } catch (e) {
      print("Ошибка загрузки заметок: $e");
    }
  }

  Future<void> _saveNote(Note note) async {
    try {
      if (note.id == null) {
        note.id = _notes.isEmpty ? 1 : _notes.last.id! + 1;
        _notes.add(note);
      } else {
        final index = _notes.indexWhere((n) => n.id == note.id);
        if (index != -1) _notes[index] = note;
      }
      await NotesFileWorker.instance.saveNotes(_notes);
      _loadNotes();
    } catch (e) {
      print("Ошибка сохранения заметки: $e");
    }
  }

  Future<void> _deleteNote(int id) async {
    try {
      _notes.removeWhere((note) => note.id == id);
      await NotesFileWorker.instance.saveNotes(_notes);
      _loadNotes();
    } catch (e) {
      print("Ошибка удаления заметки: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(
              widget.categoryName == "Контакты"
                  ? "${note.description}\nТелефон: ${note.phoneNumber ?? 'Нет'}"
                  : note.description,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final updatedNote = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotesEntry(
                          note: note,
                          categoryId: widget.categoryId,
                          categoryName: widget.categoryName,
                        ),
                      ),
                    );
                    if (updatedNote != null) await _saveNote(updatedNote);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteNote(note.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotesEntry(
                categoryId: widget.categoryId,
                categoryName: widget.categoryName,
              ),
            ),
          );
          if (newNote != null) await _saveNote(newNote);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
