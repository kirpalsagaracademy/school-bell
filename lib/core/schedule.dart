import 'package:flutter/foundation.dart';

abstract class BoardingSchedule {
  const BoardingSchedule._();

  factory BoardingSchedule.forDate({
    required int year,
    required int month,
    required int day,
  }) {
    if (month < 4 || month > 10) {
      return const WinterRoutine._();
    } else {
      return const SummerRoutine._();
    }
  }

  List<Period> get timetable;

  static Period nextPeriod(DateTime time) {
    var schedule = BoardingSchedule.forDate(
      year: time.year,
      month: time.month,
      day: time.day,
    );

    // https://api.flutter.dev/flutter/package-collection_collection/binarySearch.html
    // binarySearch(sortedList, value)

    return schedule.timetable.first;
  }
}

class SummerRoutine extends BoardingSchedule {
  const SummerRoutine._() : super._();

  @override
  List<Period> get timetable => const <Period>[
        Period(
          name: "1st period",
          start: Time(hour: 8, minute: 10),
          end: Time(hour: 8, minute: 50),
        ),
        Period(
          name: "2nd period",
          start: Time(hour: 8, minute: 50),
          end: Time(hour: 9, minute: 30),
        ),
        Period(
          name: "3rd period",
          start: Time(hour: 9, minute: 30),
          end: Time(hour: 10, minute: 10),
        ),
        Period(
          name: "4th period",
          start: Time(hour: 10, minute: 10),
          end: Time(hour: 10, minute: 50),
        ),
        Period(
          name: "5th period",
          start: Time(hour: 11, minute: 10),
          end: Time(hour: 11, minute: 50),
        ),
        Period(
          name: "6th period",
          start: Time(hour: 11, minute: 50),
          end: Time(hour: 12, minute: 25),
        ),
        Period(
          name: "7th period",
          start: Time(hour: 12, minute: 25),
          end: Time(hour: 13, minute: 00),
        ),
        Period(
          name: "8th period",
          start: Time(hour: 13, minute: 00),
          end: Time(hour: 13, minute: 35),
        ),
      ];
}

class WinterRoutine extends BoardingSchedule {
  const WinterRoutine._() : super._();

  @override
  List<Period> get timetable => const <Period>[
        Period(
          name: "1st period",
          start: Time(hour: 8, minute: 30),
          end: Time(hour: 9, minute: 10),
        ),
        Period(
          name: "2nd period",
          start: Time(hour: 9, minute: 10),
          end: Time(hour: 9, minute: 50),
        ),
        Period(
          name: "3rd period",
          start: Time(hour: 9, minute: 50),
          end: Time(hour: 10, minute: 30),
        ),
        Period(
          name: "4th period",
          start: Time(hour: 10, minute: 30),
          end: Time(hour: 11, minute: 10),
        ),
        Period(
          name: "5th period",
          start: Time(hour: 11, minute: 10),
          end: Time(hour: 11, minute: 30),
        ),
        Period(
          name: "6th period",
          start: Time(hour: 11, minute: 30),
          end: Time(hour: 12, minute: 10),
        ),
        Period(
          name: "7th period",
          start: Time(hour: 12, minute: 10),
          end: Time(hour: 13, minute: 25),
        ),
        Period(
          name: "8th period",
          start: Time(hour: 13, minute: 25),
          end: Time(hour: 14, minute: 00),
        ),
      ];
}

class Period {
  final String name;
  final Time start;
  final Time end;

  const Period({
    required this.name,
    required this.start,
    required this.end,
  });
}

class Time {
  final int hour;
  final int minute;

  const Time({required this.hour, required this.minute});
}
