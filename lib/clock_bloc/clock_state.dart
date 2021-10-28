part of 'clock_bloc.dart';

class ClockState extends Equatable {
  final DateTime currentDateTime;

  const ClockState(this.currentDateTime);

  @override
  List<Object> get props => [currentDateTime];
}
