import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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

  static Routine nextPeriod(DateTime time) {
    var schedule = Schedule.forDate(
      year: time.year,
      month: time.month,
      day: time.day,
    );

    var now = Time(hour: time.hour, minute: time.minute);
    for (var period in schedule.timetable) {
      if (period.end < now) {
        return period;
      }
    }
    throw "Could not find next period in schedule.";
    // https://api.flutter.dev/flutter/package-collection_collection/binarySearch.html
    // binarySearch(sortedList, value)
  }
}

class SummerSchedule extends Schedule {
  const SummerSchedule._() : super._();

  @override
  List<Routine> get timetable => const <Routine>[
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
      ];
}

class WinterSchedule extends Schedule {
  const WinterSchedule._() : super._();

  @override
  List<Routine> get timetable => const <Routine>[
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

class Time extends Equatable {
  final int hour;
  final int minute;

  const Time({required this.hour, required this.minute});

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
}
