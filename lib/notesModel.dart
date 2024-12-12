class Note {
  int? id;
  int categoryId;
  String title;
  String description;
  String? phoneNumber; // Поле для номера телефона

  Note({
    this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    this.phoneNumber, // Номер телефона как необязательное поле
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'title': title,
      'description': description,
      'phoneNumber': phoneNumber,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      categoryId: map['categoryId'],
      title: map['title'],
      description: map['description'],
      phoneNumber: map['phoneNumber'], // Парсинг номера телефона
    );
  }
}
