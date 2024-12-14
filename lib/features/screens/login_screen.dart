import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_task_manager/features/services/snack_bar.dart';

/*
Это экран входа, который:

Проверяет Email и пароль на корректность.
Выполняет вход через Firebase Authentication.
Обрабатывает ошибки входа и уведомляет пользователя.
Предоставляет возможность перейти на экран регистрации.
 */

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true; // скрыт ли пароль или нет
  late TextEditingController emailTextInputController; // поле ввода для почты
  late TextEditingController passwordTextInputController; // поле ввода для пароля
  final formKey = GlobalKey<FormState>(); // ключ для проверки валидности, используется для управления и проверки формы

  @override
  void initState() {
    super.initState();
    emailTextInputController = TextEditingController(); // Инициализация контроллера для почты
    passwordTextInputController = TextEditingController(); // Инициализация контроллера для пароля
  }

  @override
  void dispose() { // Освобождение ресурсов, когда экран уничтожается
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    super.dispose();
  }

  void clearInputs() { // чистит поля ввода данных
    emailTextInputController.clear();
    passwordTextInputController.clear();
  }

  void togglePasswordView() { // переключение видимости пароля
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> login() async { // вход в аккаунт
    final navigator = Navigator.of(context);

    final isValid = formKey.currentState!.validate(); // проверка валидности формы
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword( // попытка входа в аккаунт
        email: emailTextInputController.text.trim(), // убирание лишних символов
        password: passwordTextInputController.text.trim(), // убирание лишних символов
      );
    } on FirebaseAuthException catch (e) { // обработка ошибок
      print(e.code);

      if (e.code == 'user-not-found' || e.code == 'wrong-password') { // если такой почты нет или пароль неверен
        SnackBarService.showSnackBar(
          context,
          'Неправильный email или пароль. Повторите попытку',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar( // любые другие ошибки
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
        return;
      }
    }

    // очистка контроллеров после успешного входа
    clearInputs();

    // навигация на главный экран
    navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    clearInputs();// очищаем поля ввода при возврате на экран

    return Scaffold(
      resizeToAvoidBottomInset: false, // при появлении клавиатуры, сдвига интерфейса не происходит
      appBar: AppBar(
        title: const Text('Войти'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField( // форма ввода почты
                keyboardType: TextInputType.emailAddress,
                autocorrect: false, // отключение автокоррекции
                controller: emailTextInputController, // указание нужного контроллера, почты
                validator: (email) => email != null && !EmailValidator.validate(email) // проверка на валидность почты через зависимость email_validator
                    ? 'Введите правильный Email'
                    : null,
                decoration: const InputDecoration( // декор текст внутри бара
                  border: OutlineInputBorder(),
                  hintText: 'Введите Email',
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: false, // отключение автокоррекции
                controller: passwordTextInputController, // указание нужного контроллера, пароля
                obscureText: isHiddenPassword, // переменная скрытия пароля, изначально скрыт
                validator: (value) => value != null && value.length < 6 // валидатор пароля, если нет данных или кол-во символов меньше 6, то пароль не подходит
                    ? 'Минимум 6 символов'
                    : null,
                decoration: InputDecoration( // декор текст внутри бара
                  border: const OutlineInputBorder(),
                  hintText: 'Введите пароль',
                  suffix: InkWell(
                    onTap: togglePasswordView, // смена видимости пароля
                    child: Icon(
                      isHiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: login,
                child: const Center(child: Text('Войти')),
              ),
              const SizedBox(height: 30),
              TextButton( // кнопка перехода на экран регистрации
                onPressed: () => Navigator.of(context).pushNamed('/signup'),
                child: const Text(
                  'Регистрация',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
