import 'package:school_bell/schedule/schedule_model.dart';
import 'package:school_bell/time.dart';
import 'package:test/test.dart';

void main() {
  group('CountdownDisplayModel', () {
    test('Should display countdown for one hour', () {
      var countdownModel = CountdownDisplayModel(countdownInSec: 3600);

      expect(countdownModel.hours, equals('01'));
      expect(countdownModel.minutes, equals('00'));
      expect(countdownModel.seconds, equals('00'));
    });

    test('Should display countdown for one second', () {
      var countdownModel = CountdownDisplayModel(countdownInSec: 1);

      expect(countdownModel.hours, equals('00'));
      expect(countdownModel.minutes, equals('00'));
      expect(countdownModel.seconds, equals('01'));
    });

    test('Should display countdown for one minute', () {
      var countdownModel = CountdownDisplayModel(countdownInSec: 60);

      expect(countdownModel.hours, equals('00'));
      expect(countdownModel.minutes, equals('01'));
      expect(countdownModel.seconds, equals('00'));
    });

    test('Should display countdown for 22h 22m 23s', () {
      var countdownModel = CountdownDisplayModel(
        countdownInSec: 3600 * 22 + 60 * 22 + 23,
      );

      expect(countdownModel.hours, equals('22'));
      expect(countdownModel.minutes, equals('22'));
      expect(countdownModel.seconds, equals('23'));
    });

    test('Should display countdown for 3h 59m 1s', () {
      var countdownModel = CountdownDisplayModel(
        countdownInSec: 3600 * 3 + 60 * 59 + 1,
      );

      expect(countdownModel.hours, equals('03'));
      expect(countdownModel.minutes, equals('59'));
      expect(countdownModel.seconds, equals('01'));
    });
  });

  group('DateTime extensions', () {
    test('Should move date to next working day', () {
      var time = const Time(hour: 19, minute: 52);
      var date = const Date(year: 2021, month: 10, day: 22);

      var result = time.atDate(date).atNextWorkingDay();

      expect(result.weekday, equals(DateTime.monday));
      expect(result.year, equals(2021));
      expect(result.month, equals(10));
      expect(result.day, equals(25));
    });

    test('Should determine if the current date time at a weekend', () async {
      expect(DateTime(2021, 10, 30).isAtWeekend, equals(true));
      expect(DateTime(2021, 10, 31).isAtWeekend, equals(true));
      expect(DateTime(2021, 11, 01).isAtWeekend, equals(false));
    });

    test('Should format time', () async {
      var time = const Time(hour: 20, minute: 40);
      var date = const Date(year: 2021, month: 10, day: 13);

      var result = time.atDate(date).toFormattedString();

      expect(result, equals('Wednesday, 13-10-2021, 8:40p.m.'));
    });
  });

  group('Time formatting', () {
    test('Display morning time', () async {
      var time = const Time(hour: 7, minute: 55);
      expect(time.toString(), equals('07:55a.m.'));
    });

    test('Display time noon', () async {
      var time = const Time(hour: 12, minute: 15);
      expect(time.toString(), equals('12:15p.m.'));
    });

    test('Display afternoon time', () async {
      var time = const Time(hour: 19, minute: 30);
      expect(time.toString(), equals('7:30p.m.'));
    });

    test('Display midnight day start', () async {
      var time = const Time(hour: 00, minute: 00);
      expect(time.toString(), equals('0:00 midnight'));
    });

    test('Display midnight day end', () async {
      var time = const Time(hour: 24, minute: 00);
      expect(time.toString(), equals('12:00 midnight'));
    });

  });
}
