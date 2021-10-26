part of 'schedule_bloc.dart';

class ScheduleState extends Equatable {
  final Routine currentRoutine;
  final RingingModel nextRinging;

  const ScheduleState({
    required this.currentRoutine,
    required this.nextRinging,
  });

  @override
  List<Object> get props => [currentRoutine];
}
