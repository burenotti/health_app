import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/repositories/profile_repository/errors.dart';
import 'package:health_app/repositories/profile_repository/profile_repository.dart';
import 'package:health_app/repositories/user_repository/user_repo.dart';
import 'package:health_app/services/account_service/account_service.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final ProfileRepository profileRepo = GetIt.I<ProfileRepository>();
  final UserRepository userRepo = GetIt.I<UserRepository>();
  final AccountService accountService = GetIt.I<AccountService>();

  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpCoachRequired>((event, emit) async {
      emit(SignUpLoading());
      var account = accountService.account;
      // await accountService.logout();
      await initialSignUp(account.userId, event.email, event.password);

      account = accountService.account;

      try {
        await profileRepo.createCoach(
          accessToken: account.token!.accessToken,
          id: account.userId,
          firstName: event.firstName,
          lastName: event.lastName,
          birthDate: event.birthDate,
          yearsExerience: event.yearsExperience,
          bio: event.bio,
        );
      } on ProfileRepositoryError catch (e) {
        emit(SignUpFailed());
      }

      await accountService.updateProfile();

      emit(SignUpSucceed());
    });

    on<SignUpTraineeRequired>((event, emit) async {
      emit(SignUpLoading());

      var account = accountService.account;

      await initialSignUp(account.userId, event.email, event.password);
      account = accountService.account;

      try {
        await profileRepo.createTrainee(
          accessToken: account.token!.accessToken,
          id: account.userId,
          firstName: event.firstName,
          lastName: event.lastName,
          birthDate: event.birthDate,
        );
      } on ProfileRepositoryError catch (e) {
        emit(SignUpFailed());
      }

      await accountService.updateProfile();

      emit(SignUpSucceed());
    });
  }

  Future<void> initialSignUp(
    String userId,
    String email,
    String password,
  ) async {
    await userRepo.signUp(
      userId: userId,
      email: email,
      password: password,
    );

    final token = await userRepo.signIn(
      email: email,
      password: password,
    );
    accountService.setToken(token.accessToken, token.refreshToken);
  }
}
