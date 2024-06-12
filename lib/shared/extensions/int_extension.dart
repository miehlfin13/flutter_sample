extension IntExtension on int {
  String toMonthString() {
    return switch(this) {
      0 => 'PREV',
      1 => 'JAN',
      2 => 'FEB',
      3 => 'MAR',
      4 => 'APR',
      5 => 'MAY',
      6 => 'JUN',
      7 => 'JUL',
      8 => 'AUG',
      9 => 'SEP',
      10 => 'OCT',
      11 => 'NOV',
      12 => 'DEC',
      _ => ''
    };
  }

  String toFullMonthString() {
    return switch(this) {
      1 => 'January',
      2 => 'February',
      3 => 'March',
      4 => 'April',
      5 => 'May',
      6 => 'June',
      7 => 'July',
      8 => 'August',
      9 => 'September',
      10 => 'October',
      11 => 'November',
      12 => 'December',
      _ => ''
    };
  }

  String toFullWeekString() {
    return switch(this) {
      0 => 'Sunday',
      1 => 'Monday',
      2 => 'Tuesday',
      3 => 'Wednesday',
      4 => 'Thursday',
      5 => 'Friday',
      6 => 'Saturday',
      _ => ''
    };
  }

  String toOrdinal() {
    switch (this % 100) {
      case 11:
      case 12:
      case 13:
        return '${this}th';
      default:
        switch (this % 10) {
          case 1:
            return '${this}st';
          case 2:
            return '${this}nd';
          case 3:
            return '${this}rd';
          default:
            return '${this}th';
        }
    }
  }
}
