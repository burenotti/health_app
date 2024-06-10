import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/features/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:health_app/features/auth/screens/common.dart';
import 'package:talker_flutter/talker_flutter.dart';

class RegisterCoachScreen extends StatefulWidget {
  const RegisterCoachScreen({Key? key}) : super(key: key);

  @override
  RegisterCoachScreenState createState() => RegisterCoachScreenState();
}

class RegisterCoachScreenState extends State<RegisterCoachScreen> {
  final bloc = SignUpBloc();
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController(text: "John");
  final lastNameController = TextEditingController(text: "Doe");
  final emailController = TextEditingController(text: "email@example.com");
  final passwordController = TextEditingController(text: "password123");
  final yearsExperienceController = TextEditingController(text: "3");
  final bioController = TextEditingController(text: "Я крутой");
  DateTime? birthDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async{
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Регистрация тренера"),
      ),
      body: BlocConsumer<SignUpBloc, SignUpState>(
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
          return SingleChildScrollView(
            child: Form(
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
                  buildFormItem(
                    label: "Опыт работы",
                    controller: yearsExperienceController,
                    validator: (v) => null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "О себе",
                        alignLabelWithHint: true,
                      ),
                      controller: bioController,
                      maxLines: 5,
                    ),
                  ),
                  if (state is SignUpLoading)
                    const CircularProgressIndicator(),

                  if (state is! SignUpLoading)
                    FilledButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Пожалуйста, заполните все поля')));
                          return;
                        }

                        bloc.add(SignUpCoachRequired(
                          email: emailController.text,
                          password: passwordController.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          birthDate: birthDate!,
                          bio: bioController.text,
                          yearsExperience:
                              int.parse(yearsExperienceController.text),
                        ));
                      },
                      child: const Text('Зарегистрироваться'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void processSignUp() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пожалуйста, заполните все поля')));
    }
  }
}
