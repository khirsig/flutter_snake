import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake/gameplay/cubit/action_cubit.dart';
import 'package:snake/grid/models/grid.dart';
import 'package:snake/gameplay/cubit/gameplay_cubit.dart';

class BlocSnake extends StatelessWidget {
  BlocSnake({super.key});

  late final FocusNode focusNode;

  void _keyActionListener(BuildContext context, ActionState state) {
    if (state is ActionKeyBoardState) {
      BlocProvider.of<GameplayCubit>(context).moveHandler(state.key);
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
      ],
      child: BlocConsumer<ActionCubit, ActionState>(
        builder: (context, state) {
          if (state is ActionFocusNodeState) {
            focusNode = state.focusNode;
          }
          return Focus(
            autofocus: true,
            focusNode: focusNode,
            child: BlocBuilder<GameplayCubit, GridState>(
              builder: (context, state) {
                return Grid(state.gridList);
              },
            ),
          );
        },
        listener: _keyActionListener,
      ),
    ));
  }
}
