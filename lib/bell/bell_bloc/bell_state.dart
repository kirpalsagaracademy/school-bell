part of 'bell_bloc.dart';

abstract class BellState {
  const BellState();
}

class BellSilent extends BellState {
  const BellSilent();
}

class BellRinging extends BellState {
  const BellRinging();
}
