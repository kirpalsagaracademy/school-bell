import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// https://kirpalsagaracademy.com/4010000000143.html
abstract class Schedule {
  const Schedule._();

  factory Schedule.forDate({
    required int year,
    required int month,
    required int day,
  }) {
    if (month < 4 || month > 10) {
      return const WinterSchedule._();
    } else {
      return const SummerSchedule._();
    }
  }

  List<Routine> get timetable;

  static Routine currentRoutine(DateTime currentDateTime) {
    var currentTime = Time.fromDateTime(currentDateTime);
    var schedule = Schedule.forDate(
      year: currentDateTime.year,
      month: currentDateTime.month,
      day: currentDateTime.day,
    );

    for (int i = 0; i < schedule.timetable.length; i++) {
      Routine? matchingRoutine;

      var routine = schedule.timetable[i];

      if (currentTime >= routine.start && currentTime <= routine.end) {
        matchingRoutine = routine;
      }

      if (matchingRoutine == null) {
        continue;
      }

      Routine? nextRoutine;
      if (i + 1 < schedule.timetable.length) {
        nextRoutine = schedule.timetable[i + 1];
      }
      if (nextRoutine != null) {
        if (currentTime == nextRoutine.start) {
          matchingRoutine = nextRoutine;
        }
      }

      return matchingRoutine;
    }

    // Time is not defined in any official routine

    // Find routine with biggest end time before "time"
    late Routine routineJustBefore;
    for (var routine in schedule.timetable) {
      if (routine.end < currentTime) {
        routineJustBefore = routine;
      }
      if (routine.end > currentTime) {
        break;
      }
    }

    // Find routine with smallest start time after "time"
    late Routine routineJustAfterTime;
    for (var routine in schedule.timetable) {
      if (routine.start > currentTime) {
        routineJustAfterTime = routine;
        break;
      }
    }

    return SpareTime(
      start: routineJustBefore.end,
      end: routineJustAfterTime.start,
    );
  }

  static DateTime nextRinging(DateTime time) {
    var schedule = Schedule.forDate(
      year: time.year,
      month: time.month,
      day: time.day,
    );
    var now = Time(hour: time.hour, minute: time.minute);
    for (var period in schedule.timetable) {
      if (period.name.toLowerCase().contains("period") && period.end < now) {
        var dateTime = DateTime(
          time.year,
          time.month,
          time.day,
          period.start.hour,
          period.start.minute,
        );
        if (dateTime.isBefore(time)) {
          print("return created datetime plus 1 day");
          return dateTime.add(Duration(days: 1));
        } else {
          print("return created datetime");
          return dateTime;
        }
      }
    }

    throw "could not find matching time";
  }
}

class SummerSchedule extends Schedule {
  const SummerSchedule._() : super._();

  @override
  List<Routine> get timetable => const <Routine>[
        Routine(
          name: "Lights Off",
          start: Time(hour: 00, minute: 00),
          end: Time(hour: 5, minute: 25),
        ),
        Routine(
          name: "Reveille",
          start: Time(hour: 5, minute: 25),
          end: Time(hour: 5, minute: 30),
        ),
        Routine(
          name: "Morning Tea",
          start: Time(hour: 5, minute: 30),
          end: Time(hour: 5, minute: 45),
        ),
        Routine(
          name: "Physical Training",
          start: Time(hour: 5, minute: 45),
          end: Time(hour: 6, minute: 10),
        ),
        Routine(
          name: "Bath & Change",
          start: Time(hour: 6, minute: 15),
          end: Time(hour: 7, minute: 10),
        ),
        Routine(
          name: "Breakfast",
          start: Time(hour: 7, minute: 25),
          end: Time(hour: 7, minute: 45),
        ),
        Routine(
          name: "Assembly",
          start: Time(hour: 7, minute: 55),
          end: Time(hour: 8, minute: 10),
        ),
        Routine(
          name: "1st period",
          start: Time(hour: 8, minute: 10),
          end: Time(hour: 8, minute: 50),
        ),
        Routine(
          name: "2nd period",
          start: Time(hour: 8, minute: 50),
          end: Time(hour: 9, minute: 30),
        ),
        Routine(
          name: "3rd period",
          start: Time(hour: 9, minute: 30),
          end: Time(hour: 10, minute: 10),
        ),
        Routine(
          name: "4th period",
          start: Time(hour: 10, minute: 10),
          end: Time(hour: 10, minute: 50),
        ),
        Routine(
          name: "Milk break",
          start: Time(hour: 10, minute: 50),
          end: Time(hour: 11, minute: 10),
        ),
        Routine(
          name: "5th period",
          start: Time(hour: 11, minute: 10),
          end: Time(hour: 11, minute: 50),
        ),
        Routine(
          name: "6th period",
          start: Time(hour: 11, minute: 50),
          end: Time(hour: 12, minute: 25),
        ),
        Routine(
          name: "7th period",
          start: Time(hour: 12, minute: 25),
          end: Time(hour: 13, minute: 00),
        ),
        Routine(
          name: "8th period",
          start: Time(hour: 13, minute: 00),
          end: Time(hour: 13, minute: 35),
        ),
        Routine(
          name: "Lunch",
          start: Time(hour: 13, minute: 40),
          end: Time(hour: 14, minute: 00),
        ),
        Routine(
          name: "Rest / Washing",
          start: Time(hour: 14, minute: 00),
          end: Time(hour: 15, minute: 20),
        ),
        Routine(
          name: "Evening tea",
          start: Time(hour: 15, minute: 20),
          end: Time(hour: 15, minute: 45),
        ),
        Routine(
          name: "Evening Prep",
          start: Time(hour: 16, minute: 00),
          end: Time(hour: 17, minute: 30),
        ),
        Routine(
          name: "Games",
          start: Time(hour: 17, minute: 35),
          end: Time(hour: 18, minute: 40),
        ),
        Routine(
          name: "Dinner",
          start: Time(hour: 19, minute: 30),
          end: Time(hour: 19, minute: 55),
        ),
        Routine(
          name: "Night Prep.",
          start: Time(hour: 20, minute: 15),
          end: Time(hour: 21, minute: 15),
        ),
        Routine(
          name: "Lights Off",
          start: Time(hour: 21, minute: 30),
          end: Time(hour: 24, minute: 00),
        ),
      ];
}

class WinterSchedule extends Schedule {
  const WinterSchedule._() : super._();

  @override
  List<Routine> get timetable => const <Routine>[
        Routine(
          name: "Lights Off",
          start: Time(hour: 00, minute: 00),
          end: Time(hour: 5, minute: 45),
        ),
        Routine(
          name: "Reveille",
          start: Time(hour: 5, minute: 45),
          end: Time(hour: 6, minute: 00),
        ),
        Routine(
          name: "Morning Tea",
          start: Time(hour: 6, minute: 00),
          end: Time(hour: 6, minute: 10),
        ),
        Routine(
          name: "Physical Training",
          start: Time(hour: 6, minute: 10),
          end: Time(hour: 6, minute: 35),
        ),
        Routine(
          name: "Bath & Change",
          start: Time(hour: 6, minute: 40),
          end: Time(hour: 7, minute: 35),
        ),
        Routine(
          name: "Breakfast",
          start: Time(hour: 7, minute: 50),
          end: Time(hour: 8, minute: 10),
        ),
        Routine(
          name: "Assembly",
          start: Time(hour: 8, minute: 15),
          end: Time(hour: 8, minute: 30),
        ),
        Routine(
          name: "1st period",
          start: Time(hour: 8, minute: 30),
          end: Time(hour: 9, minute: 10),
        ),
        Routine(
          name: "2nd period",
          start: Time(hour: 9, minute: 10),
          end: Time(hour: 9, minute: 50),
        ),
        Routine(
          name: "3rd period",
          start: Time(hour: 9, minute: 50),
          end: Time(hour: 10, minute: 30),
        ),
        Routine(
          name: "4th period",
          start: Time(hour: 10, minute: 30),
          end: Time(hour: 11, minute: 10),
        ),
        Routine(
          name: "Milk break",
          start: Time(hour: 10, minute: 50),
          end: Time(hour: 11, minute: 11),
        ),
        Routine(
          name: "5th period",
          start: Time(hour: 11, minute: 10),
          end: Time(hour: 11, minute: 30),
        ),
        Routine(
          name: "6th period",
          start: Time(hour: 11, minute: 30),
          end: Time(hour: 12, minute: 10),
        ),
        Routine(
          name: "7th period",
          start: Time(hour: 12, minute: 10),
          end: Time(hour: 13, minute: 25),
        ),
        Routine(
          name: "8th period",
          start: Time(hour: 13, minute: 25),
          end: Time(hour: 14, minute: 00),
        ),
        Routine(
          name: "Lunch",
          start: Time(hour: 14, minute: 00),
          end: Time(hour: 14, minute: 30),
        ),
        Routine(
          name: "Rest / Washing",
          start: Time(hour: 14, minute: 30),
          end: Time(hour: 15, minute: 00),
        ),
        Routine(
          name: "Evening tea",
          start: Time(hour: 15, minute: 00),
          end: Time(hour: 15, minute: 20),
        ),
        Routine(
          name: "Evening Prep (1st)",
          start: Time(hour: 15, minute: 40),
          end: Time(hour: 16, minute: 25),
        ),
        Routine(
          name: "Evening Prep (2nd)",
          start: Time(hour: 16, minute: 25),
          end: Time(hour: 17, minute: 10),
        ),
        Routine(
          name: "Games/Remedial",
          start: Time(hour: 17, minute: 15),
          end: Time(hour: 18, minute: 15),
        ),
        Routine(
          name: "Dinner",
          start: Time(hour: 19, minute: 25),
          end: Time(hour: 19, minute: 50),
        ),
        Routine(
          name: "Night Prep.",
          start: Time(hour: 20, minute: 15),
          end: Time(hour: 21, minute: 15),
        ),
        Routine(
          name: "Lights Off",
          start: Time(hour: 22, minute: 00),
          end: Time(hour: 24, minute: 00),
        ),
      ];
}

class Routine extends Equatable {
  final String name;
  final Time start;
  final Time end;

  const Routine({
    required this.name,
    required this.start,
    required this.end,
  });

  @override
  List<Object> get props => [name, start, end];
}

class SpareTime extends Routine {
  const SpareTime({
    required Time start,
    required Time end,
  }) : super(
          name: 'Spare time',
          start: start,
          end: end,
        );
}

class Time extends Equatable {
  final int hour;
  final int minute;

  const Time({required this.hour, required this.minute});

  Time.fromDateTime(DateTime dateTime)
      : hour = dateTime.hour,
        minute = dateTime.minute;

  @override
  List<Object> get props => [hour, minute];

  bool operator <(Time other) {
    return (hour * 60 + minute) < (other.hour * 60 + other.minute);
  }

  bool operator >(Time other) {
    return (hour * 60 + minute) > (other.hour * 60 + other.minute);
  }

  bool operator >=(Time other) {
    return (hour * 60 + minute) >= (other.hour * 60 + other.minute);
  }

  // TODO Add unit test
  bool operator <=(Time other) {
    return (hour * 60 + minute) <= (other.hour * 60 + other.minute);
  }

  DateTime today() {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  DateTime atDate(Date date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}

class Date extends Equatable {
  final int year;
  final int month;
  final int day;

  const Date({required this.year, required this.month, required this.day});

  @override
  List<Object> get props => [year, month, day];
}

extension DateTimeExtension on DateTime {
  Date get date {
    return Date(year: year, month: month, day: day);
  }
}
