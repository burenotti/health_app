part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

final class SignInFailed extends SignInState {
  final String message;

  const SignInFailed({required this.message});
}

final class SignInLoading extends SignInState {}

final class SignInSuccess extends SignInState {
  final Token token;

  const SignInSuccess(this.token);

}
