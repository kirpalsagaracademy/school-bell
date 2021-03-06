import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_bell/bell/bell_bloc/bell_bloc.dart';
import 'package:school_bell/schedule/schedule_model.dart';
import 'package:school_bell/time.dart';

part 'schedule_event.dart';

part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final BellBloc _bellBloc;
  final Clock _clock = const Clock();
  late StreamSubscription<int> _clockSubscription;

  ScheduleBloc({required BellBloc bellBloc})
      : _bellBloc = bellBloc,
        super(
          ScheduleState(
            currentRoutine: Schedule.currentRoutine(DateTime.now()),
            nextRinging: Schedule.nextRinging(DateTime.now()),
          ),
        ) {
    _clockSubscription = _clock.tick().listen((event) {
      add(ClockTicked());
    });
    // TODO Why is the stack trace not printed in case of an exception?

    on<ClockTicked>((ClockTicked event, Emitter<ScheduleState> emit) {
      var newScheduleState = ScheduleState(
        currentRoutine: Schedule.currentRoutine(DateTime.now()),
        nextRinging: Schedule.nextRinging(DateTime.now()),
      );
      if (newScheduleState.nextRinging != state.nextRinging) {
        _bellBloc.add(BellRun());
      }
      emit(newScheduleState);
    });
  }

  @override
  Future<void> close() {
    _clockSubscription.cancel();
    return super.close();
  }
}
