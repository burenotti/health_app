class ProfileRepositoryError extends Error {
  final String message;
  final bool temporary;

  ProfileRepositoryError({
    required this.message,
    this.temporary = false,
  });
}

class ProfileNotFoundError extends ProfileRepositoryError {
  ProfileNotFoundError({required super.message, super.temporary = false});
}

class UnauthorizedError extends ProfileRepositoryError {
  UnauthorizedError({required super.message, super.temporary = false});
}
