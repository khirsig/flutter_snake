import 'package:flutter/material.dart';
import 'package:snake/grid/models/models.dart';

class Grid extends StatelessWidget {
  final GridList _gridList;

  const Grid(this._gridList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: _getGrid());
  }

  List<Widget> _getGrid() {
    List<Widget> grid = [];
    for (int i = 0; i < _gridList.length; i++) {
      List<Widget> row = [];
      for (int j = 0; j < _gridList[i].length; j++) {
        switch (_gridList[i][j]) {
          case 1:
            row.add(const PlayerElement());
            break;
          case 2:
            row.add(const FoodElement());
            break;
          default:
            row.add(const GridElement());
            break;
        }
      }
      grid.add(Expanded(child: Row(children: row)));
    }
    return grid;
  }
}

class GridElement extends StatelessWidget {
  final Color color;

  const GridElement({super.key, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: Colors.blueGrey,
            width: 1,
          ),
        ),
      ),
    );
  }
}

class PlayerElement extends GridElement {
  const PlayerElement({super.key, color = Colors.red}) : super(color: color);
}

class FoodElement extends GridElement {
  const FoodElement({super.key, color = Colors.green}) : super(color: color);
}
