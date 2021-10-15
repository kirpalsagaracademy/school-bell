import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bell_event.dart';
part 'bell_state.dart';

class BellBloc extends Bloc<BellEvent, BellState> {
  BellBloc() : super(const BellSilent()) {
    on<BellRun>((event, emit) {
      emit(const BellRinging());
    });
    on<BellMuted>((event, emit) {
      emit(const BellSilent());
    });
  }
}
