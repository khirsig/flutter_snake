// import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake/grid/models/models.dart';
import 'package:snake/ticker.dart';

class GridState {
  final GridList gridList;

  GridState(this.gridList);
}

class GridCubit extends Cubit<GridState> {
  final GridList _gridList = [];
  StreamSubscription<int>? _tickerSubscription;
  List<Position> playerPosition = [];
  Position playerDirection = const Position(1, 0);
  late Position foodPosition;
  bool _hasChangedDirectionThisTick = false;
  bool _paused = true;

  final int width;
  final int height;
  Ticker ticker = const Ticker();

  GridCubit({
    required this.width,
    required this.height,
  }) : super(GridState(GridList.empty())) {
    playerPosition.add(Position(width ~/ 2, height ~/ 2));
    _updateFoodPosition();
    updateGrid();
    emit(GridState(_gridList));
    start();
  }

  void start() {
    _tickerSubscription?.cancel();
    _tickerSubscription =
        ticker.tick(tickSpeed: const Duration(milliseconds: 250)).listen((_) {
      updateGrid();
      emit(GridState(_gridList));
      _hasChangedDirectionThisTick = false;
    });
    _tickerSubscription?.pause();
  }

  void changePlayerDirection({required bool leftDirection}) {
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

  void pause() {
    if (_paused == false) {
      _paused = true;
      _tickerSubscription?.pause();
    } else {
      _paused = false;
      _tickerSubscription?.resume();
    }
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
