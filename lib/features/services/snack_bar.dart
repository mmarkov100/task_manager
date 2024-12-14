import 'package:flutter/material.dart';

/*
это вспомогательный класс для удобного отображения уведомлений (SnackBar). Он:

Поддерживает уведомления двух типов: ошибки и успехи.
Гарантирует, что новый SnackBar заменяет предыдущий, если он уже отображается.
Упрощает использование SnackBar в приложении, минимизируя повторяющийся код.
 */

class SnackBarService {
  static const errorColor = Colors.red; // цвет ошибки
  static const okColor = Colors.green; // цвет удачи?

  static Future<void> showSnackBar(
      BuildContext context, String message, bool error) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar(); // удаление существующих снекбаров до инициализации нового, чтобы их не копилось много

    final snackBar = SnackBar(
      content: Text(message), // сообщение
      backgroundColor: error ? errorColor : okColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar); // показ снекбара
  }
}