class Ticker {
  const Ticker();
  Stream<int> tick({Duration tickSpeed = const Duration(seconds: 1)}) {
    return Stream.periodic(tickSpeed, (x) => x);
  }
}
