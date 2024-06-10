part of 'groups_bloc.dart';

sealed class GroupsState extends Equatable {
  final List<Group> groups;

  const GroupsState(this.groups);

  @override
  List<Object> get props => [groups];
}

final class GroupsInitial extends GroupsState {
  GroupsInitial() : super([]);
}

final class GroupsLoading extends GroupsState {
  GroupsLoading() : super([]);
}

final class GroupsLoadingFailed extends GroupsState {
  GroupsLoadingFailed() : super([]);
}

final class GroupsLoadingSuccess extends GroupsState {
  const GroupsLoadingSuccess(super.group);
}