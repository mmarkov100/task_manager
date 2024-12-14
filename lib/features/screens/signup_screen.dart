import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_task_manager/features/services/snack_bar.dart';

/*
Это экран регистрации, который:

Проверяет корректность Email и паролей.
Создаёт нового пользователя через Firebase Authentication.
Обрабатывает ошибки регистрации и уведомляет пользователя.
Перенаправляет на стартовый экран после успешной регистрации.
 */

class SignUpScreen extends StatefulWidget { // Стейтфул виджет, потому что данные на этом экране могут меняться
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  bool isHiddenPassword = true; // Пароль изначально спрятан
  TextEditingController emailTextInputController = TextEditingController(); // поле ввода для почты
  TextEditingController passwordTextInputController = TextEditingController(); // поле ввода для пароля 1
  TextEditingController passwordTextRepeatInputController = TextEditingController(); // поле ввода для пароля 2
  final formKey = GlobalKey<FormState>(); // ключ для проверки валидности, используется для управления и проверки формы


  void clearInputs() { // чистит поля ввода данных
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    passwordTextRepeatInputController.dispose();
  }

  void togglePasswordView() { // переключение видимости пароля
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> signUp() async { // фукнция регистрации
    final navigator = Navigator.of(context);

    final isValid = formKey.currentState!.validate();
    if (!isValid) return; // если форма текущего состояния не валидна, то выходим из функции

    if (passwordTextInputController.text != // если пароли из 1 и 2 баров ввода пароля не одинаковые, то
        passwordTextRepeatInputController.text) {
      SnackBarService.showSnackBar( // показываем снекбар с ошибкой, то есть красный
        context,
        'Пароли должны совпадать',
        true,
      );
      return;
    }

    try { // Если все прошло успешно, то
      await FirebaseAuth.instance.createUserWithEmailAndPassword( // создаем новый аккаунт в файрбейзе по введенным паролю и почте
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {// если есть ошибка, то
      print(e.code); // вывод ошибки

      if (e.code == 'email-already-in-use') { // если почта уже используется
        SnackBarService.showSnackBar( // показываем снекбар с ошибкой, то есть красный
          context,
          'Такой Email уже используется, повторите попытку с использованием другого Email',
          true,
        );
        return;
      } else { // если другая неизвестная ошибка
        SnackBarService.showSnackBar( // показываем снекбар с ошибкой, то есть красный
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
      }
    }

    // очистка контроллеров после успешного входа
    clearInputs();
    // если ошибок нет и регистрация прошла успешно, то перекидывает на экран Firebase_stream, удаляя предыдущую страницу
    navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // отключение сдвига
      appBar: AppBar(
        title: const Text('Зарегистрироваться'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey, // проверка валидности
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: emailTextInputController,
                validator: (email) => email != null && !EmailValidator.validate(email)
                    ? 'Введите правильный Email'
                    : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Введите Email',
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                controller: passwordTextInputController,
                obscureText: isHiddenPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Минимум 6 символов'
                    : null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Введите пароль',
                  suffix: InkWell(
                    onTap: togglePasswordView,
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
              TextFormField(
                autocorrect: false,
                controller: passwordTextRepeatInputController,
                obscureText: isHiddenPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Минимум 6 символов'
                    : null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Введите пароль еще раз',
                  suffix: InkWell(
                    onTap: togglePasswordView,
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
                onPressed: signUp, // функция регистрации
                child: const Center(child: Text('Регистрация')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}