import 'package:flutter/material.dart';
import 'categoriesModel.dart';

class CategoryEntry extends StatefulWidget {
  final Category? category;

  const CategoryEntry({super.key, this.category});

  @override
  _CategoryEntryState createState() => _CategoryEntryState();
}

class _CategoryEntryState extends State<CategoryEntry> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.category?.name ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? "Добавить категорию" : "Редактировать категорию"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Название категории"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите название категории";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newCategory = Category(
                      id: widget.category?.id,
                      name: _nameController.text,
                    );
                    Navigator.pop(context, newCategory);
                  }
                },
                child: const Text("Сохранить"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
