import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/cubits/task_cubit.dart';
import 'features/repository/task_repository.dart';
import 'features/screens/add_task_screen.dart';
import 'features/screens/task_list_screen.dart';
import 'firebase_options.dart';
import 'package:final_task_manager/features/screens/account_screen.dart';
import 'package:final_task_manager/features/screens/login_screen.dart';
import 'package:final_task_manager/features/screens/signup_screen.dart';
import 'package:final_task_manager/features/services/firebase_stream.dart';

/*
   Firebase TaskManager - Сценарии:
   Войти - Почта / Пароль
   Зарегистрироваться - Почта / Пароль два раза
   Возможность просмотра задач
   Возможность добавления новой задачи
   Отметить задачу выполненной или не выполненной
   Удалить задачу

Код представляет собой стартовую точку для приложения на Flutter с использованием Firebase. Он:
Инициализирует Firebase.
Настраивает маршруты для навигации.Предоставляет Cubit для управления состоянием задач.
Определяет начальный экран (FirebaseStream), который решает,
показывать ли экран входа (LoginScreen) или основной экран (TaskListScreen) в зависимости от статуса авторизации.
*/


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Старт флаттера в ассинхронном режиме
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Импортируем настройки в файрбейз и запускаем его до запуска самого приложения
  ); // Инициализация Firebase.
  runApp(const MyApp()); // Запуск приложения.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final taskRepository = TaskRepository(); // Создали кубит задачи, отвечает за работу с фаерстором

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => TaskCubit(taskRepository), // управление состоянием задачи
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            }),
          ),
          routes: {
            '/': (context) => const FirebaseStream(), // экран проверки авторизации
            '/account': (context) => const AccountScreen(), // экран профиля аккаунта
            '/login': (context) => const LoginScreen(), // экран входа
            '/signup': (context) => const SignUpScreen(), // экран регистрации
            '/add_task': (context) => const AddTaskScreen(), // экран добавления задачи
            '/tasks': (context) => const TaskListScreen(), // экран списка задач
          },
          initialRoute: '/', // старт
        )
    );
  }
}