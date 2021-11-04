import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_bell/time.dart';

part 'clock_event.dart';

part 'clock_state.dart';

class ClockBloc extends Bloc<ClockTicked, ClockState> {
  final Duration clockRate;
  final Clock _clock;
  late StreamSubscription<int> _clockSubscription;

  ClockBloc({required this.clockRate})
      : _clock = Clock(clockRate: clockRate),
        super(
          ClockState(DateTime.now()),
        ) {
    _clockSubscription = _clock.tick().listen((event) {
      add(ClockTicked());
    });

    on<ClockTicked>((event, emit) {
      emit(ClockState(event.currentDateTime));
    });
  }

  @override
  Future<void> close() {
    _clockSubscription.cancel();
    return super.close();
  }
}
