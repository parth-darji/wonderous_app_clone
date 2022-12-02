class StringUtils {
  static String capitalize(String value) {
    return '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
  }
}
