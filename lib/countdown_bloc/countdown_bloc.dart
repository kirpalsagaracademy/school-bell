import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:school_bell/core/time.dart';

part 'countdown_event.dart';

part 'countdown_state.dart';

class CountdownBloc extends Bloc<CountdownEvent, CountdownState> {
  final DateTime _expiration;

  final Clock _clock = const Clock();

  late StreamSubscription<int> _clockSubscription;

  CountdownBloc(this._expiration)
      : super(
          CountdownState(
            _expiration.difference(DateTime.now()).abs(),
          ),
        ) {
    print('Calling countdown bloc constructor');
    _clockSubscription = _clock.tick().listen((event) {
      add(ClockTicked());
    });

    on<CountdownEvent>((CountdownEvent event, Emitter<CountdownState> emit) {
      emit(
          CountdownState(
            _expiration.difference(DateTime.now()).abs(),
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
