part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

enum SignUpType { coach, trainee }

class SignUpRequired extends SignUpEvent {
  final SignUpType type;
  const SignUpRequired(this.type);
}

class SignUpTraineeRequired extends SignUpRequired {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final DateTime birthDate;

  const SignUpTraineeRequired({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  }) : super(SignUpType.coach);
}

class SignUpCoachRequired extends SignUpRequired {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String bio;
  final int yearsExperience;

  const SignUpCoachRequired({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    this.bio = "",
    this.yearsExperience = 0,
  }) : super(SignUpType.trainee);
}
