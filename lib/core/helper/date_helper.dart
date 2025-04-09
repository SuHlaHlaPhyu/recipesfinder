class DateHelper {
  static const weekdays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  static String dayFromDate(DateTime date) {
    return weekdays[date.weekday % 7];
  }
}
