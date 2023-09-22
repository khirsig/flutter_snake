typedef GridList = List<List<int>>;

class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  @override
  bool operator ==(Object other) {
    return other is Position && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x ^ y;

  Position operator +(Position other) {
    return Position(x + other.x, y + other.y);
  }

  Position operator -(Position other) {
    return Position(x - other.x, y - other.y);
  }
}
