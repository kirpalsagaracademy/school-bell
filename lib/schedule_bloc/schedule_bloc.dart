import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_bell/bell_bloc/bell_bloc.dart';
import 'package:school_bell/core/schedule.dart';
import 'package:school_bell/core/time.dart';
import 'package:uuid/uuid.dart';

part 'schedule_event.dart';

part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final Clock _clock = const Clock();

  late StreamSubscription<int> _clockSubscription;

  ScheduleBloc()
      : super(
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
      emit(
          ScheduleState(
            currentRoutine: Schedule.currentRoutine(DateTime.now()),
            nextRinging: Schedule.nextRinging(DateTime.now()),
          )
      );
    });
  }

  @override
  Future<void> close() {
    _clockSubscription.cancel();
    return super.close();
  }
}

