List<int> generateRangeList(List<int> range) {
  final int first = range[0];
  final int last = range[1];

  return List<int>.generate(last - first + 1, (int index) => first + index);
}
