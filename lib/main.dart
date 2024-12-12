import 'package:flutter/material.dart';
import 'categoriesList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Информационный менеджер',
      home: CategoriesList(),
    );
  }
}
