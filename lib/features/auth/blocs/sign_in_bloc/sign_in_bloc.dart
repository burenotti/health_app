import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/repositories/user_repository/errors.dart';
import 'package:health_app/repositories/user_repository/models.dart';
import 'package:health_app/repositories/user_repository/user_repo.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository userRepo;
  final AccountService accountService;

  SignInBloc(
    this.userRepo,
    this.accountService,
  ) : super(SignInInitial()) {
    on<SignInRequired>(processSignIn);
    on<SignOutRequired>(
        (event, emit) => GetIt.I<Talker>().info("Sign out required"));
  }

  Future<void> processSignIn(
    SignInRequired event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading());
    try {
      final token =
          await userRepo.signIn(email: event.email, password: event.password);

      accountService.setToken(token.accessToken, token.refreshToken);
      await accountService.updateProfile();
      emit(SignInSuccess(token));
    } on UserRepositoryError catch (e) {
      emit(SignInFailed(message: e.message));
    } catch (e) {
      emit(const SignInFailed(message: "Произошла ошибка, попробуйте позже"));
    }
  }
}
