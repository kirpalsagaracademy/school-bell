

const secondsInHour = 3600;
const secondsInMinute = 60;

class CountdownDisplayModel {
  final int _countdownInSec;

  CountdownDisplayModel({required int countdownInSec})
      : _countdownInSec = countdownInSec;

  String get hours {
    int _hours = _countdownInSec ~/ secondsInHour;
    return _hours.toString().padLeft(2, "0");
  }

  String get minutes {
    int _minutes = (_countdownInSec % secondsInHour) ~/ secondsInMinute;
    return _minutes.toString().padLeft(2, "0");
  }

  String get seconds {
    int _seconds = (_countdownInSec % secondsInHour) % secondsInMinute;
    return _seconds.toString().padLeft(2, "0");
  }
}

extension DateTimeExtension on DateTime {

  DateTime atNextWorkingDay() {
    late int offset;
    if (weekday < DateTime.friday || weekday == DateTime.sunday) {
      offset = 1;
    } else if (weekday == DateTime.friday) {
      offset = 3;
    } else if (weekday == DateTime.saturday) {
      offset = 2;
    }
    return add(Duration(days: offset));
  }
}