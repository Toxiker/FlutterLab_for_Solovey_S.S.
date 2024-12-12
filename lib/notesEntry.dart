import 'package:flutter/material.dart';
import 'notesModel.dart';

class NotesEntry extends StatefulWidget {
  final Note? note;
  final int categoryId;
  final String categoryName;

  NotesEntry({this.note, required this.categoryId, required this.categoryName});

  @override
  _NotesEntryState createState() => _NotesEntryState();
}

class _NotesEntryState extends State<NotesEntry> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _descriptionController = TextEditingController(text: widget.note?.description ?? "");
    _phoneController = TextEditingController(text: widget.note?.phoneNumber ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "Добавить заметку" : "Редактировать заметку"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Название"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите название";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Описание"),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите описание";
                  }
                  return null;
                },
              ),
              if (widget.categoryName == "Контакты") // Поле для ввода номера только для "Контакты"
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Номер телефона"),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !RegExp(r'^\d+$').hasMatch(value)) {
                      return "Введите только цифры";
                    }
                    return null;
                  },
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newNote = Note(
                      id: widget.note?.id,
                      categoryId: widget.categoryId,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      phoneNumber: widget.categoryName == "Контакты"
                          ? _phoneController.text
                          : null, // Сохраняем номер только для "Контактов"
                    );
                    Navigator.pop(context, newNote);
                  }
                },
                child: Text("Сохранить"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
