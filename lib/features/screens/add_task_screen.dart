import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../cubits/task_cubit.dart';
import '../models/task.dart';

/*
это экран для добавления новой задачи. Он:

Проверяет, авторизован ли пользователь.
Позволяет ввести название и описание задачи.
Сохраняет задачу, привязывая её к текущему пользователю через uid.
Возвращает пользователя на предыдущий экран после успешного добавления задачи.
 */

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController(); // бар ввода названия
  final _descriptionController = TextEditingController(); // бар ввода описаня
  final _auth = FirebaseAuth.instance; // получение инфы об текущем пользователе

  void _saveTask() {
    final currentUser = _auth.currentUser; // получаем юзера

    if (currentUser == null) { // если ошибка сущестовования пользователя
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return;
    }

    final task = Task( // обьект задачи
      id: '', // сам генерится
      uid: currentUser.uid, // привязка к юзеру
      title: _titleController.text, // название задачи
      description: _descriptionController.text, // описание
      isCompleted: false, // выполенение, изначально false
    );

    context.read<TaskCubit>().addTask(task); // добавляем задачу
    Navigator.pop(context); // обратно на экран задач
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить задачу')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField( // бар ввода названия
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            const SizedBox(height: 8),
            TextField( // бар ввода описания
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            const SizedBox(height: 16),
            ElevatedButton( // кнопка сохранения задачи
              onPressed: _saveTask,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
