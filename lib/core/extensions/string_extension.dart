extension StringX on String {
  String get formated {
    try {
      final parts = split('_');

      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      int hr = int.parse(parts[3]);
      int min = int.parse(parts[4]);

      final time = DateTime(year, month, day, hr, min);

      String formattedDate =
          "${time.day} ${getMonthName(time.month)} ${time.year} ${hour(time.hour)}:${time.minute} ${getAmPm(time.hour)}";

      return formattedDate;
    } catch (_) {
      return this;
    }
  }

  int hour(int hr) {
    return hr > 12 ? hr - 12 : hr;
  }

  String getAmPm(int hour) {
    return hour < 12 ? 'AM' : 'PM';
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'JAN';
      case 2:
        return 'FEB';
      case 3:
        return 'MAR';
      case 4:
        return 'APR';
      case 5:
        return 'MAY';
      case 6:
        return 'JUN';
      case 7:
        return 'JUL';
      case 8:
        return 'AUG';
      case 9:
        return 'SEPT';
      case 10:
        return 'OCT';
      case 11:
        return 'NOV';
      case 12:
        return 'DEC';
      default:
        return 'Invalid month';
    }
  }
}
