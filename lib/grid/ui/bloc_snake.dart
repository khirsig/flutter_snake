import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake/grid/models/grid.dart';
import 'package:snake/grid/cubit/grid_cubit.dart';

class BlocSnake extends StatelessWidget {
  BlocSnake({super.key});

  final FocusNode activeFocus = FocusNode(
    onKeyEvent: (node, event) {
      if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.arrowLeft &&
          node.hasFocus) {
        BlocProvider.of<GridCubit>(node.context!)
            .changePlayerDirection(leftDirection: true);
        return KeyEventResult.handled;
      } else if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.arrowRight &&
          node.hasFocus) {
        BlocProvider.of<GridCubit>(node.context!)
            .changePlayerDirection(leftDirection: false);
        return KeyEventResult.handled;
      } else if (event is KeyDownEvent &&
          event.logicalKey == LogicalKeyboardKey.space &&
          node.hasFocus) {
        BlocProvider.of<GridCubit>(node.context!).pause();
      }
      return KeyEventResult.ignored;
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => GridCubit(
        width: 20,
        height: 15,
      ),
      child: BlocBuilder<GridCubit, GridState>(
        builder: (context, state) {
          return Focus(
            autofocus: true,
            focusNode: activeFocus,
            child: Grid(state.gridList),
          );
        },
      ),
    ));
  }
}
