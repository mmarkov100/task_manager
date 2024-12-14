import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:final_task_manager/features/screens/login_screen.dart';
import '../cubits/task_cubit.dart';
import '../screens/task_list_screen.dart';

/*
Этот файл выполняет роль диспетчера состояния авторизации.
Если пользователь авторизован, отображается экран задач, а задачи пользователя загружаются из базы.
Если пользователь не авторизован, приложение очищает список задач и показывает экран входа.
Обрабатываются возможные ошибки с помощью простого сообщения на экране.
Этот файл — важная связка между Firebase Authentication и логикой приложения.
 */

class FirebaseStream extends StatelessWidget {
  const FirebaseStream({super.key});

  @override
  Widget build(BuildContext context) {
    final taskCubit = context.read<TaskCubit>();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // поток данных для отслеживания авторизации пользователя
      builder: (context, snapshot) { // билдер обработки данных с потока
        if (snapshot.hasError) { // если есть ошибка при загрузке страницы, то выводится ошибка
          return const Scaffold(
              body: Center(child: Text('Что-то пошло не так!')));
        } else if (snapshot.hasData) { // если юзер авторизован, то переходим на экран задач
          taskCubit.loadTasks(snapshot.data!.uid);
          return const TaskListScreen();
        } else { // иначе переход на экран логина
          taskCubit.clearTasks();
          return const LoginScreen();
        }
      },
    );
  }
}