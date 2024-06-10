part of 'group_detail_bloc.dart';

sealed class GroupDetailState extends Equatable {
  const GroupDetailState();

  @override
  List<Object> get props => [];
}

final class GroupDetailInitial extends GroupDetailState {}

final class GroupDetailLoading extends GroupDetailState {}

final class GroupDetailLoadingFailed extends GroupDetailState {}

final class GroupDetailLoadingSucceed extends GroupDetailState {
  final Group group;
  final List<Member> members;
  const GroupDetailLoadingSucceed(this.group, this.members);  
}
