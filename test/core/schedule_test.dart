import 'package:flutter/cupertino.dart';
import 'package:school_bell/core/schedule.dart';
import "package:test/test.dart";

void main() {
  group('Should determine whether to use winter or summer routine', () {
    test('Should use summer routine', () {
      expect(
        Schedule.forDate(year: 2021, month: 04, day: 01),
        const TypeMatcher<SummerSchedule>(),
      );
      expect(
        Schedule.forDate(year: 2021, month: 10, day: 31),
        const TypeMatcher<SummerSchedule>(),
      );
    });

    test('Should use winter routine', () {
      expect(
        Schedule.forDate(year: 2021, month: 11, day: 01),
        const TypeMatcher<WinterSchedule>(),
      );
      expect(
        Schedule.forDate(year: 2022, month: 03, day: 31),
        const TypeMatcher<WinterSchedule>(),
      );
    });
  });

  group('Should calculate current period', () {
    test('Should default to spare time if not specified', () {
      var time = const Time(hour: 20, minute: 00);
      var date = const Date(year: 2021, month: 10, day: 19);

      var currentRoutine = Schedule.currentRoutine(time.atDate(date));

      expect(currentRoutine.name, equals('Spare time'));
      expect(currentRoutine.start, equals(const Time(hour: 19, minute: 55)));
      expect(currentRoutine.end, equals(const Time(hour: 20, minute: 15)));
    });

    test('Should find out current period', () {

    });

    test('Should not apply schedule on Saturday', () {

    });

    test('Should not apply schedule on Sunday', () {

    });
  });

  group('Should calculate next ringing', () {
    test('Should ring with first period of the current day', () {

    });

    test('Should ring with first period of next day', () {

    });

    test('Should ring with next period', () {

    });
  });

  // TODO Probably this should be moved into "time_test.dart".
  group('Time comparison', () {
    test('Should determine time before', () {
      var before = const Time(hour: 8, minute: 00);
      var after = const Time(hour: 8, minute: 10);

      expect(before < after, isTrue);
      expect(after < before, isFalse);
    });

    test('Should determine time after', () {
      var before = const Time(hour: 8, minute: 00);
      var after = const Time(hour: 8, minute: 10);

      expect(after > before, isTrue);
      expect(before > after, isFalse);
    });

    test('Should determine equal time', () {
      var time1 = const Time(hour: 8, minute: 00);
      var time2 = const Time(hour: 8, minute: 00);

      expect(time1 >= time2, isTrue);
      expect(time2 >= time1, isTrue);
    });

    test('Should calculate time in schedule', () {
      var time = const Time(hour: 8, minute: 00);

      DateTime timeToday = time.today();

      expect(timeToday.hour, equals(time.hour));
      expect(timeToday.minute, equals(time.minute));
    });
  });
}
