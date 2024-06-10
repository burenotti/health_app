import 'dart:core';

class UserRepositoryError extends Error {
  String message;
  bool temporary;

  UserRepositoryError({
    required this.message,
    this.temporary = false,
  });
}

class UserBadRequestError extends UserRepositoryError {
  UserBadRequestError({
    required super.message,
    super.temporary,
  });
}

class UserUnauthorizedError extends UserRepositoryError {
  UserUnauthorizedError({
    required super.message,
    super.temporary,
  });
}
