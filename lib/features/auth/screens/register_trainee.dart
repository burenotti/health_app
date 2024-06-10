import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/features/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:health_app/features/auth/screens/common.dart';
import 'package:talker_flutter/talker_flutter.dart';

class RegisterTraineeScreen extends StatefulWidget {
  const RegisterTraineeScreen({Key? key}) : super(key: key);

  @override
  RegisterTraineeScreenState createState() => RegisterTraineeScreenState();
}

class RegisterTraineeScreenState extends State<RegisterTraineeScreen> {
  final _formKey = GlobalKey<FormState>();
  SignUpBloc bloc = SignUpBloc();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DateTime? birthDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Регистрация"),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<SignUpBloc, SignUpState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is SignUpSucceed) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.of(context).popAndPushNamed("/");
              });
            }
            if (state is SignUpFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Произошла ошибка")));
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
                      label: "Адрес электронной почты",
                      controller: emailController,
                      validator: (v) => null),
                  buildFormItem(
                    label: "Пароль",
                    controller: passwordController,
                    validator: (v) => null,
                  ),
                  buildFormItem(
                    label: "Имя",
                    controller: firstNameController,
                    validator: (v) => null,
                  ),
                  buildFormItem(
                    label: "Фамилия",
                    controller: lastNameController,
                    validator: (v) => null,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InputDatePickerFormField(
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        keyboardType: TextInputType.datetime,
                        fieldLabelText: "Дата рождения",
                        acceptEmptyDate: false,
                        errorFormatText: "Введите корректную дату",
                        errorInvalidText: "Введите корректную дату",
                        onDateSubmitted: (date) {
                          birthDate = date;
                          GetIt.I<Talker>().info("selected date $birthDate");
                        }),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Пожалуйста, заполните все поля')));
                      }

                      bloc.add(SignUpTraineeRequired(
                        email: emailController.text,
                        password: passwordController.text,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        birthDate: birthDate!,
                      ));
                    },
                    child: const Text('Зарегистрироваться'),
                  ),
                  TextButton(
                    child: const Text("Регистрация для тренеров"),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/profile/coach/create");
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
