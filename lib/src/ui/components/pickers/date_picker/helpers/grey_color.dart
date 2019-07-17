List<int> greyColourInclude(List<int> res, int n) {
  final List<int> result = List<int>.from(res);

  for (int i = 0; i < n; i++) {
    result[i] = -result[i].abs();
  }

  return result;
}

List<int> greyColourBegin(List<int> res, int n) {
  final List<int> result = List<int>.from(res);

  for (int i = n; i < res.length; i++) {
    result[i] = -result[i].abs();
  }

  return result;
}
