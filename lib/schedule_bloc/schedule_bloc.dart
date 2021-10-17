import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_bell/bell_bloc/bell_bloc.dart';
import 'package:school_bell/core/schedule.dart';
import 'package:uuid/uuid.dart';

part 'schedule_event.dart';

part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  //final BellBloc _bellBloc;

  final _Clock _clock = const _Clock();

  late StreamSubscription<int> _clockSubscription;

  ScheduleBloc()
      : super(
          ScheduleState(
              currentRoutine: Schedule.nextPeriod(DateTime.now()),
              nextRinging: Schedule.nextRinging(DateTime.now())),
        ) {
    try {
      _clockSubscription = _clock.tick().listen((event) {
        add(ClockTicked());
      });
    } catch (e) {
      print("Hello");
    }
    ;
    // print("Hello");

    on<ClockTicked>((event, emit) {
      print("On clock ticked");
      emit(
        ScheduleState(
          currentRoutine: Schedule.nextPeriod(DateTime.now()),
          nextRinging: Schedule.nextRinging(DateTime.now()),
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _clockSubscription.cancel();
    return super.close();
  }
}

class _Clock {
  const _Clock();

  Stream<int> tick() {
    return Stream.periodic(Duration(seconds: 1), (x) => x++);
  }
}
