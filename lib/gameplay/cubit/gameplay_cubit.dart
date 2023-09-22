// import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake/grid/models/models.dart';

class GameplayState {}

class GameplayGridState extends GameplayState {
  final GridList gridList;

  GameplayGridState(this.gridList);
}

class GameplayPauseState extends GameplayState {}

class GameplayCubit extends Cubit<GameplayState> {
  final GridList _gridList = [];
  List<Position> playerPosition = [];
  Position playerDirection = const Position(1, 0);
  late Position foodPosition;
  bool _hasChangedDirectionThisTick = false;
  bool _gameOver = false;

  final int width;
  final int height;

  GameplayCubit({
    required this.width,
    required this.height,
  }) : super(GameplayState()) {
    playerPosition.add(Position(width ~/ 2, height ~/ 2));
    _updateFoodPosition();
    updateGrid();
    emit(GameplayGridState(_gridList));
  }

  void reset() {
    _gameOver = false;
    playerPosition.clear();
    playerPosition.add(Position(width ~/ 2, height ~/ 2));
    _updateFoodPosition();
    updateGrid();
    emit(GameplayGridState(_gridList));
  }

  void tickAction() {
    updateGrid();
    emit(GameplayGridState(_gridList));
    _hasChangedDirectionThisTick = false;
  }

  void moveHandler(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.arrowLeft) {
      _changePlayerDirection(leftDirection: true);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      _changePlayerDirection(leftDirection: false);
    } else if (key == LogicalKeyboardKey.space) {
      _pause();
    }
  }

  void _changePlayerDirection({required bool leftDirection}) {
    if (_hasChangedDirectionThisTick == true) {
      return;
    }
    if (!leftDirection) {
      if (playerDirection.x == 0) {
        playerDirection = Position(playerDirection.y, 0);
      } else {
        playerDirection = Position(0, -playerDirection.x);
      }
    } else {
      if (playerDirection.y == 0) {
        playerDirection = Position(0, playerDirection.x);
      } else {
        playerDirection = Position(-playerDirection.y, 0);
      }
    }
    _hasChangedDirectionThisTick = true;
  }

  void _pause() {
    if (_gameOver == true) {
      reset();
      return;
    }

    emit(GameplayPauseState());
  }

  void updateGrid() {
    _updatePlayerPosition();
    _gridList.clear();
    for (int x = 0; x < width; x++) {
      if (_gridList.length <= x) {
        _gridList.add([]);
      }
      for (int y = 0; y < height; y++) {
        if (_gridList[x].length <= y) {
          if (playerPosition.contains(Position(x, y))) {
            _gridList[x].add(1);
          } else if (x == foodPosition.x && y == foodPosition.y) {
            _gridList[x].add(2);
          } else {
            _gridList[x].add(0);
          }
        }
      }
    }
  }

  void _updatePlayerPosition() {
    Position oldPosition = playerPosition.first;
    for (int i = 0; i < playerPosition.length; i++) {
      if (i == 0) {
        playerPosition[i] += playerDirection;

        if (playerPosition[i].x < 0) {
          playerPosition[i] = Position(width - 1, playerPosition[i].y);
        } else if (playerPosition[i].x >= width) {
          playerPosition[i] = Position(0, playerPosition[i].y);
        } else if (playerPosition[i].y < 0) {
          playerPosition[i] = Position(playerPosition[i].x, height - 1);
        } else if (playerPosition[i].y >= height) {
          playerPosition[i] = Position(playerPosition[i].x, 0);
        }
      } else {
        var tempPosition = oldPosition;
        oldPosition = playerPosition[i];
        playerPosition[i] = tempPosition;
      }
    }

    Map<dynamic, dynamic> map = {};

    playerPosition.forEach((pos) {
      if (!map.containsKey(pos)) {
        map[pos] = 1;
      } else {
        _gameOver = true;
        // _tickerSubscription?.pause();
        emit(GameplayPauseState());
      }
    });

    bool ateFood = false;
    while (playerPosition.contains(foodPosition)) {
      _updateFoodPosition();
      ateFood = true;
    }
    if (ateFood) {
      playerPosition.add(oldPosition);
    }
  }

  void _updateFoodPosition() {
    foodPosition = _getRandomPosInBounds();
  }

  Position _getRandomPosInBounds() {
    return Position(Random().nextInt(width), Random().nextInt(height));
  }
}
