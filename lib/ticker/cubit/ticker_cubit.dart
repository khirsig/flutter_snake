import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TimerState {}

class PauseState extends TimerState {}

class TimerTickState extends TimerState {}

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(PauseState());

  void pause() {
    emit(PauseState());
  }
}
