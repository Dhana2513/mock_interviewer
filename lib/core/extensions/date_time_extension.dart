extension DateTimeX on DateTime {
  String get toFileName {
    return '${day}_${month}_${year}_${hour}_$minute';
  }
}
