bool isNotNull(Object o) {
  return o != null;
}

bool isNotNullableString(Object string) {
  return (string is String) && (string.isNotEmpty);
}
