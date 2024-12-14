import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/task_cubit.dart';
import '../models/task.dart';
import 'account_screen.dart';

/*
основной экран, который:

Показывает список задач пользователя.
Позволяет добавлять новые задачи (через кнопку "Добавить").
Позволяет управлять выполнением задач (через Checkbox).
Позволяет удалять задачи (через долгое нажатие).
Предоставляет переход к экрану аккаунта.
 */

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskCubit = context.read<TaskCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => {
              Navigator.pushNamed(context, '/add_task') // переход на экран создания задачи
            },
          ),
          IconButton( // кнопка перехода на экран аккаунта
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AccountScreen()),
              );
            },
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, List<Task>>( // чекаем изменения состояния taskcubit
        builder: (context, tasks) {
          if (tasks.isEmpty) { // если список пустой, то
            return const Center(child: Text('Задач нет!'));
          }
          return ListView.builder( // иначе построение списка задач
            itemCount: tasks.length, // берем кол-во задач
            itemBuilder: (context, index) {
              final task = tasks[index]; // берем задачу из массива задач
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) { // при нажатии обновляется выполнение задачи
                    taskCubit.updateTask(task.copyWith(isCompleted: value!));
                  },
                ),
                onLongPress: () => taskCubit.deleteTask(task.id), // при долгом нажатии удаление задачи
              );
            },
          );
        },
      ),
    );
  }
}
