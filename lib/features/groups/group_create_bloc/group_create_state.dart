part of 'group_create_bloc.dart';

sealed class GroupCreateState extends Equatable {
  const GroupCreateState();

  @override
  List<Object> get props => [];
}

final class GroupCreateInitial extends GroupCreateState {}

final class GroupCreateInProgress extends GroupCreateState {}

final class GroupCreateFailed extends GroupCreateState {}

final class GroupCreateDone extends GroupCreateState {
  final String groupId;

  const GroupCreateDone(this.groupId);
}
