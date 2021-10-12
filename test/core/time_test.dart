import 'package:school_bell/core/time.dart';
import "package:test/test.dart";

void main() {
  group('CountdownDisplayModel', () {
    test('Should display countdown for one hour', () {
      var countdownModel = CountdownDisplayModel(countdownInSec: 3600);

      expect(countdownModel.hours, equals("01"));
      expect(countdownModel.minutes, equals("00"));
      expect(countdownModel.seconds, equals("00"));
    });

    test('Should display countdown for one second', () {
      var countdownModel = CountdownDisplayModel(countdownInSec: 1);

      expect(countdownModel.hours, equals("00"));
      expect(countdownModel.minutes, equals("00"));
      expect(countdownModel.seconds, equals("01"));
    });

    test('Should display countdown for one minute', () {
      var countdownModel = CountdownDisplayModel(countdownInSec: 60);

      expect(countdownModel.hours, equals("00"));
      expect(countdownModel.minutes, equals("01"));
      expect(countdownModel.seconds, equals("00"));
    });

    test('Should display countdown for 22h 22m 23s', () {
      var countdownModel = CountdownDisplayModel(
        countdownInSec: 3600 * 22 + 60 * 22 + 23,
      );

      expect(countdownModel.hours, equals("22"));
      expect(countdownModel.minutes, equals("22"));
      expect(countdownModel.seconds, equals("23"));
    });

    test('Should display countdown for 3h 59m 1s', () {
      var countdownModel = CountdownDisplayModel(
        countdownInSec: 3600 * 3 + 60 * 59 + 1,
      );

      expect(countdownModel.hours, equals("03"));
      expect(countdownModel.minutes, equals("59"));
      expect(countdownModel.seconds, equals("01"));
    });
  });
}
