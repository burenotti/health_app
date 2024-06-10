part of 'account_bloc.dart';

enum AccountStatus { authenticated, unauthenticated, unknown }

enum MessageType { error, info }

class Message extends Equatable {
  final String message;
  final MessageType type;

  const Message({
    required this.message,
    required this.type,
  });

  @override
  List<Object> get props => [message, type];
}

class AccountState extends Equatable {
  final AccountStatus status;
  final Account? account;
  final List<Message> messages;

  const AccountState._(this.status, this.account, this.messages);

  AccountState.unknown() : this._(AccountStatus.unknown, null, []);

  AccountState.unauthenticated()
      : this._(AccountStatus.unauthenticated, null, []);

  AccountState.authenticated(Account account)
      : this._(AccountStatus.authenticated, account, []);

  @override
  List<Object?> get props => [status, account];
}
