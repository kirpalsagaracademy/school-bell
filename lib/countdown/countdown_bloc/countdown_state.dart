part of 'countdown_bloc.dart';

// TODO Move getters from 'CountdownDisplayModel' into the 'CountdownState' class
class CountdownState extends Equatable {
  final Duration timeLeft;

  const CountdownState(this.timeLeft);

  // TODO Migrate unit tests

  @override
  List<Object> get props => [timeLeft];

  String get hours {
    int _hours = timeLeft.inSeconds ~/ secondsInHour;
    return _hours.toString().padLeft(2, '0');
  }

  String get minutes {
    int _minutes = (timeLeft.inSeconds % secondsInHour) ~/ secondsInMinute;
    return _minutes.toString().padLeft(2, '0');
  }

  String get seconds {
    int _seconds = (timeLeft.inSeconds % secondsInHour) % secondsInMinute;
    return _seconds.toString().padLeft(2, '0');
  }
}
