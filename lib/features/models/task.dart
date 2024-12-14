/*
это модель данных задачи, которая:

Представляет структуру задачи (связь с пользователем, название, описание, статус выполнения).
Позволяет преобразовывать данные между объектами Dart и форматом Map<String, dynamic> для Firestore.
Поддерживает метод copyWith, который помогает обновлять поля объекта без необходимости вручную копировать остальные поля.
 */

class Task { // структура поля задачи
  final String id;
  final String uid;
  final String title;
  final String description;
  final bool isCompleted;

  Task({
    required this.id,
    required this.uid,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  factory Task.fromMap(Map<String, dynamic> map, String documentId) {
    return Task(
      id: documentId,
      uid: map['uid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  Task copyWith({
    String? id,
    String? uid,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
