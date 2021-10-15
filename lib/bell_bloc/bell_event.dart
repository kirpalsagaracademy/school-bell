part of 'bell_bloc.dart';

abstract class BellEvent extends Equatable {
  const BellEvent();
}

class BellRun extends BellEvent {
  @override
  List<Object?> get props => [];
}

class BellMuted extends BellEvent {
  @override
  List<Object?> get props => [];
}
