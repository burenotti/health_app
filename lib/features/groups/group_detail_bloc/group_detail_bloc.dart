import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/repositories/group_repository/group_repository.dart';
import 'package:health_app/repositories/group_repository/models.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'group_detail_event.dart';
part 'group_detail_state.dart';

class GroupDetailBloc extends Bloc<GroupDetailEvent, GroupDetailState> {
  final groupRepo = GetIt.I<GroupRepository>();
  final accountService = GetIt.I<AccountService>();

  GroupDetailBloc() : super(GroupDetailInitial()) {
    on<GroupDetailRequired>((event, emit) async {
      emit(GroupDetailLoading());
      try {
        final token = accountService.account.token!.accessToken;
        final group = await groupRepo.getGroupById(token, event.groupId);
        final members = await groupRepo.getGroupMembers(token, event.groupId);
        emit(GroupDetailLoadingSucceed(group, members));
      } on Exception catch (e) {
        GetIt.I<Talker>().error(e);
        emit(GroupDetailLoadingFailed());
      }
    });
  }
}
