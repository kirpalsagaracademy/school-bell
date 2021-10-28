part of 'clock_bloc.dart';

class ClockTicked extends Equatable {
  final DateTime currentDateTime;

  ClockTicked() : currentDateTime = DateTime.now();

  @override
  List<Object?> get props => [currentDateTime];
}
