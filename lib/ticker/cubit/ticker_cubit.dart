import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake/ticker/ticker.dart';

abstract class TickState {}

class PauseState extends TickState {}

class TickerTickState extends TickState {}

class TickerCubit extends Cubit<TickState> {
  Ticker ticker = const Ticker();
  StreamSubscription<int>? _tickerSubscription;

  TickerCubit() : super(PauseState()) {
    _tickerSubscription?.cancel();
    _tickerSubscription =
        ticker.tick(tickSpeed: const Duration(milliseconds: 250)).listen((_) {
      emit(TickerTickState());
    });
    _tickerSubscription?.pause();
  }

  void pause() {
    if (_tickerSubscription!.isPaused) {
      _tickerSubscription?.resume();
    } else {
      _tickerSubscription?.pause();
      emit(PauseState());
    }
  }
}
