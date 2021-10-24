import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:school_bell/core/time.dart';

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

  List<Routine> get periods {
    return timetable
        .where((element) => element.name.toLowerCase().contains('period'))
        .toList();
  }

  static Routine currentRoutine(DateTime currentDateTime) {
    if (currentDateTime.weekday == DateTime.saturday) {
      return const Saturday();
    }

    if (currentDateTime.weekday == DateTime.sunday) {
      return const Sunday();
    }

    var currentTime = Time.fromDateTime(currentDateTime);
    var schedule = Schedule.forDate(
      year: currentDateTime.year,
      month: currentDateTime.month,
      day: currentDateTime.day,
    );

    Routine? matchingRoutine = _findMatchingRoutine(
      schedule.timetable,
      currentTime,
    );
    if (matchingRoutine != null) {
      return matchingRoutine;
    }

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

  static RingingModel nextRinging(DateTime currentDateTime) {
    var schedule = Schedule.forDate(
      year: currentDateTime.year,
      month: currentDateTime.month,
      day: currentDateTime.day,
    );
    var currentTime = Time(
      hour: currentDateTime.hour,
      minute: currentDateTime.minute,
    );
    var currentDate = Date(
      year: currentDateTime.year,
      month: currentDateTime.month,
      day: currentDateTime.day,
    );

    var endOfLastPeriodToday = schedule.periods.last.end.atDate(currentDate);
    if (currentDateTime.isAfter(endOfLastPeriodToday)) {
      var futureDateTime = currentDateTime.atNextWorkingDay();
      // TODO Instead of shifting the current date/time to the next working day
      //  there should be a property providing access on the next working day
      //  as date.
      var nextWorkingDay = Date(
        year: futureDateTime.year,
        month: futureDateTime.month,
        day: futureDateTime.day,
      );
      var firstPeriod = schedule.periods.first;
      var startFirstPeriodNextWorkingDay = firstPeriod.start.atDate(
        nextWorkingDay,
      );
      return RingingModel(
        startFirstPeriodNextWorkingDay,
        firstPeriod,
      );
    }

    for (int i = 0; i < schedule.timetable.length; i++) {
      var routine = schedule.timetable[i];

      Routine? nextRoutine;
      if (i + 1 < schedule.timetable.length) {
        nextRoutine = schedule.timetable[i + 1];
      }

      if (routine.isSchoolPeriod) {
        if (routine.start > currentTime) {
          var routineStartAtCurrentDay = routine.start.atDate(Date(
            year: currentDateTime.year,
            month: currentDateTime.month,
            day: currentDateTime.day,
          ));

          if (routineStartAtCurrentDay.isBefore(currentDateTime)) {
            // FIXME The day offset calculation here is obsolete
            return RingingModel(
              // TODO Improve readability of this expression
              routineStartAtCurrentDay.atNextWorkingDay(),
              routine,
            );
          } else {
            return RingingModel(
              routineStartAtCurrentDay,
              routine,
            );
          }
        }

        if (nextRoutine != null) {
          if (nextRoutine.start > currentTime) {
            var routineStartAtCurrentDay = nextRoutine.start.atDate(Date(
              year: currentDateTime.year,
              month: currentDateTime.month,
              day: currentDateTime.day,
            ));

            return RingingModel(
              routineStartAtCurrentDay,
              nextRoutine,
            );
          }
        }
      }
    }

    throw "could not find matching time";
  }

  static Routine? _findMatchingRoutine(
    List<Routine> timetable,
    Time currentTime,
  ) {
    Routine? matchingRoutine;
    for (int i = 0; i < timetable.length; i++) {
      var routine = timetable[i];

      if (currentTime >= routine.start && currentTime <= routine.end) {
        matchingRoutine = routine;
      }

      if (matchingRoutine == null) {
        continue;
      }

      Routine? nextRoutine;
      if (i + 1 < timetable.length) {
        nextRoutine = timetable[i + 1];
      }
      if (nextRoutine != null && currentTime == nextRoutine.start) {
        matchingRoutine = nextRoutine;
      }
      break;
    }
    return matchingRoutine;
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

  // TODO Add unit test
  bool get isSchoolPeriod {
    return name.toLowerCase().contains('period');
  }
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

class Saturday extends Routine {
  const Saturday()
      : super(
          name: 'Saturday',
          start: const Time(hour: 00, minute: 00),
          end: const Time(hour: 24, minute: 00),
        );
}

class Sunday extends Routine {
  const Sunday()
      : super(
          name: 'Sunday',
          start: const Time(hour: 00, minute: 00),
          end: const Time(hour: 24, minute: 00),
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

class RingingModel {
  final DateTime dateTime;
  final Routine routine;

  RingingModel(this.dateTime, this.routine);
}
