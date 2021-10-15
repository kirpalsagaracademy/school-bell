part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();
}

class ClockTicked extends ScheduleEvent {
  final DateTime time = DateTime.now();

  @override
  List<Object> get props => [time];
}
