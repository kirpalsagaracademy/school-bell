import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_bell/core/schedule.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial(Schedule.nextPeriod(DateTime.now()))) {
    on<ScheduleEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
