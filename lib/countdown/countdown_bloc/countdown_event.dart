part of 'countdown_bloc.dart';

abstract class CountdownEvent extends Equatable {
  const CountdownEvent();
}

class ClockTicked extends CountdownEvent {
  final DateTime time = DateTime.now();

  @override
  List<Object> get props => [time];
}
