part of 'trainee_bloc.dart';

sealed class TraineeState extends Equatable {
  const TraineeState();
  
  @override
  List<Object> get props => [];
}

final class TraineeInitial extends TraineeState {}

final class TraineeLoading extends TraineeState {}

final class TraineeLoadingFailed extends TraineeState {}

final class TraineeLoadingSucceed extends TraineeState {
  
}
