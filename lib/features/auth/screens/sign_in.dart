import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/features/auth/blocs/sign_in_bloc/sign_in_bloc.dart';

import 'package:health_app/repositories/user_repository/user_repo.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'common.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _block = SignInBloc(GetIt.I<UserRepository>(), GetIt.I<AccountService>());
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignInBloc, SignInState>(
        bloc: _block,
        listener: (context, state) {
          if (state is SignInSuccess) {
            Navigator.of(context).popAndPushNamed("/");
          }

          if (state is SignInFailed) {
            final snackBar = SnackBar(content: Text(state.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }

        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildFormItem(
                  controller: emailController,
                  label: "Почта",
                  validator: validateEmail,
                ),
                buildFormItem(
                  controller: passwordController,
                  label: "Пароль",
                  validator: validatePassword,
                ),
                if (state is SignInLoading) const CircularProgressIndicator(),
                if (state is! SignInLoading)
                  FilledButton(
                    onPressed: processLogin,
                    child: const Text("Войти"),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/auth/register");
                    },
                    child: const Text("Регистрация"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void processLogin() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Пожалуйста, заполните все поля')));
    }
    _block.add(SignInRequired(
      email: emailController.text,
      password: passwordController.text,
    ));
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Введите адрес электронной почты';
    }

    // TODO: implement email check

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Введите пароль';
    }
    return null;
  }
}
