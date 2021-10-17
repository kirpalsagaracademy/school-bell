import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_bell/bell_bloc/bell_bloc.dart';
import 'package:school_bell/core/schedule.dart';

part 'schedule_event.dart';

part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final BellBloc _bellBloc;

  ScheduleBloc(this._bellBloc)
      : super(
          ScheduleState(
              currentRoutine: Schedule.nextPeriod(DateTime.now()),
              nextRinging: Schedule.nextRinging(DateTime.now())),
        ) {
    on<ClockTicked>((event, emit) {
      if (event.time.isAfter(state.currentRoutine.end.today())) {
        _bellBloc.add(BellRun());
        emit(ScheduleState(
          currentRoutine: Schedule.nextPeriod(event.time),
          nextRinging: Schedule.nextRinging(event.time),
        ));
      } else {
        emit(state);
      }
    });
  }
}
