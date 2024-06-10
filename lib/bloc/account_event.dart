part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

final class AccountStateChanged extends AccountEvent {
  final Account? account;

  const AccountStateChanged({required this.account});

  @override
  List<Object?> get props => [account];

}

// final class SignUpEvent extends AccountEvent {
//   final String email;
//   final String password;

//   const SignUpEvent({required this.email, required this.password});

//   @override
//   List<Object> get props => [email, password];
// }

// final class CreateTraineeProfileEvent extends AccountEvent {
//   final String firstName;
//   final String lastName;
//   final DateTime birthDate;

//   const CreateTraineeProfileEvent(
//       {required this.firstName,
//       required this.lastName,
//       required this.birthDate});

//   @override
//   List<Object> get props => [firstName, lastName, birthDate];
// }

// final class CreateCoachProfileEvent extends AccountEvent {
//   final String firstName;
//   final String lastName;
//   final DateTime birthDate;
//   final String bio;
//   final int yearsExerience;

//   const CreateCoachProfileEvent({
//     required this.firstName,
//     required this.lastName,
//     required this.birthDate,
//     required this.bio,
//     required this.yearsExerience,
//   });

//   @override
//   List<Object> get props =>
//       [firstName, lastName, birthDate, bio, yearsExerience];
// }

// final class SignInEvent extends AccountEvent {
//   String email;
//   String password;

//   SignInEvent({required this.email, required this.password});

//   @override
//   List<Object> get props => [email, password];
// }
