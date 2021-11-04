import 'package:school_bell/schedule/schedule_model.dart';
import 'package:test/test.dart';

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

      expect(currentRoutine.name, equals('Slack time'));
      expect(currentRoutine.start, equals(const Time(hour: 19, minute: 55)));
      expect(currentRoutine.end, equals(const Time(hour: 20, minute: 15)));
    });

    test('Should find out current routine with start of period', () {
      var time = const Time(hour: 8, minute: 10);
      var date = const Date(year: 2021, month: 10, day: 19);

      var currentRoutine = Schedule.currentRoutine(time.atDate(date));

      expect(currentRoutine.name, equals('1st period'));
      expect(currentRoutine.start, equals(const Time(hour: 8, minute: 10)));
      expect(currentRoutine.end, equals(const Time(hour: 8, minute: 50)));
    });

    test('Should find out current routine with period in progress', () {
      var time = const Time(hour: 8, minute: 15);
      var date = const Date(year: 2021, month: 10, day: 19);

      var currentRoutine = Schedule.currentRoutine(time.atDate(date));

      expect(currentRoutine.name, equals('1st period'));
      expect(currentRoutine.start, equals(const Time(hour: 8, minute: 10)));
      expect(currentRoutine.end, equals(const Time(hour: 8, minute: 50)));
    });

    test('Should not apply schedule on Saturday', () {
      var time = const Time(hour: 8, minute: 15);
      var date = const Date(year: 2021, month: 10, day: 23);

      var currentRoutine = Schedule.currentRoutine(time.atDate(date));

      expect(currentRoutine.name, equals('Saturday'));
      expect(currentRoutine.start, equals(const Time(hour: 00, minute: 00)));
      expect(currentRoutine.end, equals(const Time(hour: 24, minute: 00)));
    });

    test('Should not apply schedule on Sunday', () {
      var time = const Time(hour: 8, minute: 15);
      var date = const Date(year: 2021, month: 10, day: 24);

      var currentRoutine = Schedule.currentRoutine(time.atDate(date));

      expect(currentRoutine.name, equals('Sunday'));
      expect(currentRoutine.start, equals(const Time(hour: 00, minute: 00)));
      expect(currentRoutine.end, equals(const Time(hour: 24, minute: 00)));
    });
  });

  group('Should calculate next ringing', () {
    test('Should ring at start of first period of the current day', () {
      var time = const Time(hour: 6, minute: 52);
      var date = const Date(year: 2021, month: 10, day: 21);

      var ringing = Schedule.nextRinging(time.atDate(date));

      expect(ringing.routine.name, equals('1st period'));
      expect(ringing.routine.start, equals(const Time(hour: 8, minute: 10)));
      expect(ringing.routine.end, equals(const Time(hour: 8, minute: 50)));
    });

    test('Should ring at start of next period', () {
      var time = const Time(hour: 8, minute: 15);
      var date = const Date(year: 2021, month: 10, day: 22);

      var ringing = Schedule.nextRinging(time.atDate(date));

      expect(ringing.routine.name, equals('2nd period'));
      expect(ringing.dateTime.day, equals(22));
      expect(ringing.routine.start, equals(const Time(hour: 8, minute: 50)));
    });

    test('Should ring at end of school routine before break', () {
      var time = const Time(hour: 10, minute: 30);
      var date = const Date(year: 2021, month: 10, day: 22);

      var ringing = Schedule.nextRinging(time.atDate(date));

      expect(ringing.routine.name, equals('Milk break'));
      expect(ringing.dateTime.day, equals(22));
      expect(ringing.dateTime.hour, equals(10));
      expect(ringing.dateTime.minute, equals(50));
    });

    test('Should ring at start of school routine after break', () {});

    test('Should ring at start of first period of next day', () {
      var time = const Time(hour: 19, minute: 52);
      var date = const Date(year: 2021, month: 10, day: 21);

      var ringing = Schedule.nextRinging(time.atDate(date));

      expect(ringing.dateTime.day, equals(22));
      expect(ringing.routine.name, equals('1st period'));
      expect(ringing.routine.start, equals(const Time(hour: 8, minute: 10)));
      expect(ringing.routine.end, equals(const Time(hour: 8, minute: 50)));
    });

    test('Should ring at start of first period at day after weekend', () {
      var time = const Time(hour: 19, minute: 52);
      var date = const Date(year: 2021, month: 10, day: 22);

      var ringing = Schedule.nextRinging(time.atDate(date));

      expect(ringing.dateTime.day, equals(25));
      expect(ringing.routine.name, equals('1st period'));
      expect(ringing.routine.start, equals(const Time(hour: 8, minute: 10)));
      expect(ringing.routine.end, equals(const Time(hour: 8, minute: 50)));
    });

    test('Should calculate at start of first period at day after weekend',
        () async {
      var time = const Time(hour: 6, minute: 24);
      var date = const Date(year: 2021, month: 10, day: 23);

      var ringing = Schedule.nextRinging(time.atDate(date));

      expect(ringing.dateTime.day, equals(25));
      expect(ringing.routine.name, equals('1st period'));
      expect(ringing.routine.start, equals(const Time(hour: 8, minute: 10)));
      expect(ringing.routine.end, equals(const Time(hour: 8, minute: 50)));
    });

    test(
        'Should calculate at start of first period at day after weekend using '
        'different schedule', () async {
      var time = const Time(hour: 6, minute: 24);
      var date = const Date(year: 2021, month: 10, day: 30);

      var ringing = Schedule.nextRinging(time.atDate(date));

      expect(ringing.dateTime.day, equals(1));
      expect(ringing.routine.name, equals('1st period'));
      expect(ringing.routine.start, equals(const Time(hour: 8, minute: 30)));
    });
  });

  group('Routine', () {
    test('Should determine that a routine is a school routine', () async {
      var period = Schedule.forDate(year: 2021, month: 10, day: 28)
          .timetable
          .firstWhere((element) => element.name == '1st period');
      expect(period.isSchoolPeriod, equals(true));
    });

    test('Should determine that a routine is not a school routine', () async {
      var period = Schedule.forDate(year: 2021, month: 10, day: 28)
          .timetable
          .firstWhere((element) => element.name == 'Morning Tea');
      expect(period.isSchoolPeriod, equals(false));
    });

    test('Should calculate progress percentage', () async {
      var period = Schedule.forDate(year: 2021, month: 10, day: 28)
          .timetable
          .firstWhere((element) => element.name == 'Bath & Change');

      var percentage = period.progressPercentage(DateTime(2021, 10, 28, 6, 50));

      expect(percentage, closeTo(63.64, 0.005));
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
