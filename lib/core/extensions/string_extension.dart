import 'package:recase/recase.dart';

extension StringX on String {
  String get camelCase {
    return ReCase(this).camelCase;
  }

  String get sentenceCase {
    return ReCase(this).sentenceCase;
  }


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
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Invalid month';
    }
  }
}
