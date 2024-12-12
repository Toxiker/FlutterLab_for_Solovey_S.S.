import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'categoriesModel.dart';

class CategoriesFileWorker {
  static final CategoriesFileWorker instance = CategoriesFileWorker._();
  CategoriesFileWorker._();

  Future<List<Map<String, dynamic>>> readCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('categories') ?? '[]';

      // Если данных нет, инициализируем стандартные категории
      if (data == '[]') {
        await _initializeDefaultCategories();
        return _initializeDefaultCategories();
      }
      return List<Map<String, dynamic>>.from(jsonDecode(data));
    } catch (e) {
      print("Ошибка чтения категорий: $e");
      return [];
    }
  }

  Future<void> writeCategories(List<Map<String, dynamic>> categories) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('categories', jsonEncode(categories));
    } catch (e) {
      print("Ошибка записи категорий: $e");
    }
  }

  Future<List<Map<String, dynamic>>> _initializeDefaultCategories() async {
    final defaultCategories = [
      {'id': 1, 'name': 'Встречи'},
      {'id': 2, 'name': 'Контакты'},
      {'id': 3, 'name': 'Заметки'},
      {'id': 4, 'name': 'Задачи'}
    ];
    await writeCategories(defaultCategories);
    return defaultCategories;
  }
}
