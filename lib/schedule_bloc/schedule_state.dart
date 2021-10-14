part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  final Routine currentPeriod;

  const ScheduleState(this.currentPeriod);

  @override
  List<Object> get props => [currentPeriod];
}

class ScheduleInitial extends ScheduleState {
  const ScheduleInitial(Routine currentPeriod) : super(currentPeriod);

  @override
  List<Object> get props => [];
}

class ClockTicked extends ScheduleState {
  final DateTime time = DateTime.now();

  ClockTicked(Routine currentPeriod) : super(currentPeriod);

  @override
  List<Object> get props => [time];
}

class PeriodStarted extends ScheduleState {
  const PeriodStarted(Routine currentPeriod) : super(currentPeriod);

  @override
  List<Object> get props => [];
}

class PeriodEnded extends ScheduleState {
  const PeriodEnded(Routine currentPeriod) : super(currentPeriod);

  @override
  List<Object> get props => [];
}
