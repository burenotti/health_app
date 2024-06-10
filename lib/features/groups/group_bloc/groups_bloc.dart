import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/repositories/group_repository/group_repository.dart';
import 'package:health_app/repositories/group_repository/models.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final groupRepo = GetIt.I<GroupRepository>();
  final accountService = GetIt.I<AccountService>();

  GroupsBloc() : super(GroupsInitial()) {
    on<GroupsListRequired>((event, emit) async {
      emit(GroupsLoading());
      final accessToken = accountService.account.token!.accessToken;
      try {
        final groupsList = await groupRepo.getGroupsList(accessToken);
        emit(GroupsLoadingSuccess(groupsList));
      } on Exception catch (e) {
        GetIt.I<Talker>().error(e);
        emit(GroupsLoadingFailed());
      }
    });
  }
}
