double parseMoneyValue(int value) {
  return value != null ? (value / 100).toDouble() : value;
}
