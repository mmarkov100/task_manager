import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../repository/task_repository.dart';

/*
управляет состоянием задач в приложении. Он:

Обрабатывает CRUD-операции (добавление, обновление, удаление) через TaskRepository.
Обновляет состояние задач через метод emit, синхронизируясь с Firestore в реальном времени.
Очищает состояние при необходимости, например, при выходе из аккаунта.
 */

class TaskCubit extends Cubit<List<Task>> {
  final TaskRepository _repository;

  TaskCubit(this._repository) : super([]);

  void loadTasks(String uid) { // загрузка текущих задач
    _repository.fetchTasks(uid).listen((tasks) {
      emit(tasks);
    });
  }

  // Добавление задачи
  Future<void> addTask(Task task) async {// добавить задачу
    await _repository.addTask(task);
  }

  Future<void> updateTask(Task task) async { // обновить задачи
    await _repository.updateTask(task);
  }

  Future<void> deleteTask(String taskId) async { // удалить задачу
    await _repository.deleteTask(taskId);
  }

  void clearTasks() { //очищает список задач из кеша? при выходе из аккаунта например
    emit([]);
  }
}
