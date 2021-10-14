import 'package:school_bell/core/schedule.dart';
import "package:test/test.dart";

void main() {
  group('Summer vs. Winter time', () {
    test('Should use Summer schedule', () {
      expect(
        Schedule.forDate(year: 2021, month: 04, day: 01),
        const TypeMatcher<SummerSchedule>(),
      );
      expect(
        Schedule.forDate(year: 2021, month: 10, day: 31),
        const TypeMatcher<SummerSchedule>(),
      );
    });

    test('Should use Winter schedule', () {
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

  group('Calculate next period', () {
    test('Should calculate first period starting in ten minutes', () {
      var now = DateTime(2021, 10, 13, 08, 00);
      var nextPeriod = Schedule.nextPeriod(now);

      expect(nextPeriod.name, equals("1st period"));
    });

    test('Should calculate first period at next day', () {
      var now = DateTime(2021, 10, 13, 17, 00);
      var nextPeriod = Schedule.nextPeriod(now);

      expect(nextPeriod.name, equals("1st period"));
    });
  });

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
  });
}
