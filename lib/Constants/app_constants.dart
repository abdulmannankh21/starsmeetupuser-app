DateTime convertTimeStringToDateTime(
    int year, int month, int day, String timeString) {
  // Assuming timeString is in the format "08:00 AM"
  final timeComponents = timeString.split(' ');
  final time = timeComponents[0];
  final period = timeComponents[1];

  final hourMinute = time.split(':');
  int hour = int.parse(hourMinute[0]);
  int minute = int.parse(hourMinute[1]);

  if (period.toLowerCase() == 'pm' && hour != 12) {
    hour += 12;
  } else if (period.toLowerCase() == 'am' && hour == 12) {
    hour = 0;
  }

  return DateTime(year, month, day, hour, minute);
}
