import 'models.dart';

abstract class AbstractUserRepository {
  Future<void> signUp({
    required String userId,
    required String email,
    required String password,
  });

  Future<Token> signIn({
    required String email,
    required String password,
  });

  Future<Token> refresh({
    required String refreshToken
  });

  Future<void> logout({
    required String accessToken,
  });
}
