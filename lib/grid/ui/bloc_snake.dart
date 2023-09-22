import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake/gameplay/cubit/action_cubit.dart';
import 'package:snake/grid/models/grid.dart';
import 'package:snake/gameplay/cubit/gameplay_cubit.dart';
import 'package:snake/grid/models/models.dart';
import 'package:snake/ticker/cubit/ticker_cubit.dart';

// ignore: must_be_immutable
class BlocSnake extends StatelessWidget {
  BlocSnake({super.key});

  late final FocusNode focusNode;
  GridList gridList = GridList.empty();

  void _keyActionListener(BuildContext context, ActionState state) {
    if (state is ActionKeyBoardState) {
      BlocProvider.of<GameplayCubit>(context).moveHandler(state.key);
    }
  }

  void _tickerListener(BuildContext context, TickState state) {
    if (state is TickerTickState) {
      BlocProvider.of<GameplayCubit>(context).tickAction();
    }
  }

  void _pauseListener(BuildContext context, GameplayState state) {
    if (state is GameplayPauseState) {
      BlocProvider.of<TickerCubit>(context).pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ActionCubit(),
        ),
        BlocProvider(
          create: (context) => GameplayCubit(
            width: 20,
            height: 15,
          ),
        ),
        BlocProvider(
          create: (context) => TickerCubit(),
        ),
      ],
      child: BlocListener<TickerCubit, TickState>(
        listener: _tickerListener,
        child: BlocConsumer<ActionCubit, ActionState>(
          builder: (context, state) {
            if (state is ActionFocusNodeState) {
              focusNode = state.focusNode;
            }
            return Focus(
              autofocus: true,
              focusNode: focusNode,
              child: BlocConsumer<GameplayCubit, GameplayState>(
                builder: (context, state) {
                  if (state is GameplayGridState) {
                    gridList = state.gridList;
                  }
                  return Grid(gridList);
                },
                listener: _pauseListener,
              ),
            );
          },
          listener: _keyActionListener,
        ),
      ),
    ));
  }
}
