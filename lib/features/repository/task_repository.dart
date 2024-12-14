// lib/features/repository/task_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

/*инкапсулирует логику взаимодействия с Firestore. Он:

Позволяет добавлять, обновлять и удалять задачи.
Фильтрует задачи по uid текущего пользователя для изоляции данных.
Возвращает поток задач, автоматически обновляющийся при изменении данных в Firestore.
 */

class TaskRepository {
  final _tasksCollection = FirebaseFirestore.instance.collection('tasks'); // связываемся с таблицей tasks в firestore

  Future<void> addTask(Task task) async { // добавить задачу в таблицу
    await _tasksCollection.add(task.toMap());
  }

  Future<void> updateTask(Task task) async { // обновить задачу
    await _tasksCollection.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async { // удалить задачу
    await _tasksCollection.doc(taskId).delete();
  }

  Stream<List<Task>> fetchTasks(String uid) { // фильтр задач по юзерам
    return _tasksCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Task.fromMap(doc.data(), doc.id)).toList());
  }
}
