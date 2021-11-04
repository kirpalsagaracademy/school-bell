import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bell_bloc/bell_bloc.dart';

const schoolBellSoundUrl = 'https://kirpalsagaracademy.github.io/school-bell/'
    'assets/assets/school_bell_sound.mp3';

class BellListener extends StatelessWidget {
  final Widget child;

  const BellListener({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bellBloc = context.read<BellBloc>();
    return BlocListener<BellBloc, BellState>(
      bloc: bellBloc,
      listener: (context, state) async {
        if (state is BellRinging) {
          AudioPlayer audioPlayer = AudioPlayer();
          await audioPlayer.play(schoolBellSoundUrl);
          bellBloc.add(BellMuted());
        }
      },
      child: child,
    );
  }
}
