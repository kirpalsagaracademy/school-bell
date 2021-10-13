import 'package:school_bell/core/schedule.dart';
import "package:test/test.dart";

void main() {
  group('Summer vs. Winter time', () {
    test('Should use Summer schedule', () {
      expect(
        BoardingSchedule.forDate(year: 2021, month: 04, day: 01),
        const TypeMatcher<SummerRoutine>(),
      );
      expect(
        BoardingSchedule.forDate(year: 2021, month: 10, day: 31),
        const TypeMatcher<SummerRoutine>(),
      );
    });

    test('Should use Winter schedule', () {
      expect(
        BoardingSchedule.forDate(year: 2021, month: 11, day: 01),
        const TypeMatcher<WinterRoutine>(),
      );
      expect(
        BoardingSchedule.forDate(year: 2022, month: 03, day: 31),
        const TypeMatcher<WinterRoutine>(),
      );
    });
  });

  group('Calculate next period', () {
    test('Should calculate first period starting in ten minutes', () {
      var now = DateTime(2021, 10, 13, 08, 00);
      var nextPeriod = BoardingSchedule.nextPeriod(now);

      expect(nextPeriod.name, equals("1st period"));
    });

    test('Should calculate first period at next day', () {
      var now = DateTime(2021, 10, 13, 17, 00);
      var nextPeriod = BoardingSchedule.nextPeriod(now);

      expect(nextPeriod.name, equals("1st period"));
    });
  });
}
