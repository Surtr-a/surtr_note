class TimeUtil {
  static String getSimpleDateStr(DateTime dateTime) {
    String str = dateTime.toString();
    int index = str.lastIndexOf(':') + 3;
    return str.substring(0, index);
  }

  static String getTimeIntervalStr(DateTime createAt) {
    String timeIntervalStr;

    var duration = DateTime.now().difference(createAt);
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    if (days == 0) {
      if (hours == 0) {
        if (minutes == 0) {
          timeIntervalStr = '刚刚';
        } else {
          timeIntervalStr = '${minutes}m';
        }
      } else {
        timeIntervalStr = '${hours}h';
      }
    } else if (days < 7) {
      timeIntervalStr = '${days}d';
    } else {
      timeIntervalStr = '${createAt.day} ${month[createAt.month]}';
    }

    return timeIntervalStr;
  }

  static const Map<int, String> month = {
    01: 'Jan',
    02: 'Feb',
    03: 'Mar',
    04: 'Apr',
    05: 'May',
    06: 'Jun',
    07: 'Jul',
    08: 'Aug',
    09: 'Sept',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };
}