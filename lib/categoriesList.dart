import 'package:flutter/material.dart';
import 'categoriesFileWorker.dart';
import 'categoriesModel.dart';
import 'notesList.dart';
import 'categoriesEntry.dart';

class CategoriesList extends StatefulWidget {
  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final data = await CategoriesFileWorker.instance.readCategories();
      setState(() {
        _categories = data.map((e) => Category.fromMap(e)).toList();
      });
      print("Категории загружены: $_categories");
    } catch (e) {
      print("Ошибка загрузки категорий: $e");
    }
  }

  Future<void> _saveCategory(Category category) async {
    try {
      final data = _categories.map((e) => e.toMap()).toList();

      if (category.id == null) {
        // Новая категория
        category.id = data.isEmpty ? 1 : data.last['id'] + 1;
        data.add(category.toMap());
      } else {
        // Обновление существующей категории
        final index = data.indexWhere((item) => item['id'] == category.id);
        if (index != -1) {
          data[index] = category.toMap();
        }
      }

      await CategoriesFileWorker.instance.writeCategories(data);
      await _loadCategories();
    } catch (e) {
      print("Ошибка при сохранении категории: $e");
    }
  }

  Future<void> _deleteCategory(int id) async {
    try {
      final data = _categories.where((c) => c.id != id).map((e) => e.toMap()).toList();
      await CategoriesFileWorker.instance.writeCategories(data);
      await _loadCategories();
    } catch (e) {
      print("Ошибка при удалении категории: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Категории')),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return ListTile(
            title: Text(category.name),
            onTap: () {
              // Переход к заметкам этой категории
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotesList(
                    categoryId: category.id!,
                    categoryName: category.name, // Передаём название категории
                  ),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final updatedCategory = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryEntry(category: category),
                      ),
                    );
                    if (updatedCategory != null) {
                      await _saveCategory(updatedCategory);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteCategory(category.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCategory = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryEntry()),
          );
          if (newCategory != null) {
            await _saveCategory(newCategory);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
