import 'package:school_bell/core/schedule.dart';

const secondsInHour = 3600;
const secondsInMinute = 60;

class CountdownDisplayModel {
  final int _countdownInSec;

  CountdownDisplayModel({required int countdownInSec}) : _countdownInSec = countdownInSec;

  String get hours {
    int _hours = _countdownInSec ~/ secondsInHour;
    return _hours.toString().padLeft(2, '0');
  }

  String get minutes {
    int _minutes = (_countdownInSec % secondsInHour) ~/ secondsInMinute;
    return _minutes.toString().padLeft(2, '0');
  }

  String get seconds {
    int _seconds = (_countdownInSec % secondsInHour) % secondsInMinute;
    return _seconds.toString().padLeft(2, '0');
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

  bool get isAtWeekend {
    if (weekday == DateTime.saturday) {
      return true;
    }

    if (weekday == DateTime.sunday) {
      return true;
    }

    return false;
  }

  String toFormattedString() {
    late String formattedDayOfWeek;
    switch(weekday) {
      case DateTime.monday:
        formattedDayOfWeek = 'Monday';
        break;
      case DateTime.tuesday:
        formattedDayOfWeek = 'Tuesday';
        break;
      case DateTime.wednesday:
        formattedDayOfWeek = 'Wednesday';
        break;
      case DateTime.thursday:
        formattedDayOfWeek = 'Thursday';
        break;
      case DateTime.friday:
        formattedDayOfWeek = 'Friday';
        break;
      case DateTime.saturday:
        formattedDayOfWeek = 'Saturday';
        break;
      case DateTime.sunday:
        formattedDayOfWeek = 'Sunday';
        break;
    }

    var formattedMonth = month.toString().padLeft(2, '0');
    var formattedDay = day.toString().padLeft(2, '0');
    var formattedDate = '$formattedDay-$formattedMonth-$year';

    var formattedTime = Time(hour: hour, minute: minute).toString();

    return '$formattedDayOfWeek, $formattedDate, $formattedTime';
  }
}

class Clock {
  final Duration clockRate;

  const Clock({this.clockRate = const Duration(seconds: 1)});

  Stream<int> tick() {
    return Stream.periodic(clockRate, (x) => x++);
  }
}
