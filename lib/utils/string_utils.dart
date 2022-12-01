class StringUtils {
  static String capitalize(String value) {
    return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
  }

  static String supplant(String value, Map<String, String> supplants) {
    return value.replaceAllMapped(RegExp(r'\{\w+\}'), (match) {
      final placeholder = match.group(0) ?? '';
      if (supplants.containsKey(placeholder)) {
        return supplants[placeholder]!;
      }
      return placeholder;
    });
  }
}
