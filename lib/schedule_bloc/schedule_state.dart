part of 'schedule_bloc.dart';

class ScheduleState extends Equatable {
  final Routine currentRoutine;

  const ScheduleState(this.currentRoutine);

  @override
  List<Object> get props => [currentRoutine];
}
