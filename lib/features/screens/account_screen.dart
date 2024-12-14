import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/*
это экран управления аккаунтом пользователя. Он:

Показывает информацию о текущем пользователе (Email и UID).
Предоставляет возможность выйти из аккаунта через:
Кнопку "Выйти" в AppBar.
Кнопку "Выйти" в теле экрана.
При выходе из аккаунта перенаправляет пользователя на стартовый экран.
 */

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final user = FirebaseAuth.instance.currentUser; // получаем юзера

  Future<void> signOut() async { // функция выхода из аккаунта
    final navigator = Navigator.of(context);

    await FirebaseAuth.instance.signOut(); // выход из аккаунта

    // возврат на начальный экран
    navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(// кнопка перехода на экран назад, в данном случае экран чатов
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Аккаунт'),
        actions: [
          IconButton( // кнопка выхода из аккаунта
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти из аккаунта',
            onPressed: () => signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // выравнивание виджетов по центру
          children: [
            Text('Ваш Email: ${user?.email}'),
            Text('Ваш UID: ${user?.uid}'),
            TextButton(
              onPressed: () => signOut(),
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }
}
