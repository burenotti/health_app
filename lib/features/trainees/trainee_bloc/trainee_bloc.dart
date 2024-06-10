import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'trainee_event.dart';
part 'trainee_state.dart';

class TraineeBloc extends Bloc<TraineeEvent, TraineeState> {
  TraineeBloc() : super(TraineeInitial()) {
    on<TraineeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
