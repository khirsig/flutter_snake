import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionState {}

class ActionKeyBoardState extends ActionState {
  final LogicalKeyboardKey key;

  ActionKeyBoardState(this.key);
}

class ActionFocusNodeState extends ActionState {
  final FocusNode focusNode;

  ActionFocusNodeState(this.focusNode);
}

class ActionCubit extends Cubit<ActionState> {
  FocusNode activeFocusNode = FocusNode();

  ActionCubit() : super(ActionState()) {
    activeFocusNode.onKeyEvent = _onKeyEvent;
    emit(ActionFocusNodeState(activeFocusNode));
  }

  KeyEventResult _onKeyEvent(node, event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.arrowLeft &&
        node.hasFocus) {
      emit(ActionKeyBoardState(LogicalKeyboardKey.arrowLeft));
      return KeyEventResult.handled;
    } else if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.arrowRight &&
        node.hasFocus) {
      emit(ActionKeyBoardState(LogicalKeyboardKey.arrowRight));
      return KeyEventResult.handled;
    } else if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.space &&
        node.hasFocus) {
      emit(ActionKeyBoardState(LogicalKeyboardKey.space));
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
