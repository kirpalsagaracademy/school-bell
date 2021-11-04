import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform_detect/platform_detect.dart';
import 'package:school_bell/bell/bell_bloc/bell_bloc.dart';
import 'package:school_bell/countdown/timer_card.dart';
import 'package:school_bell/schedule/schedule_bloc/schedule_bloc.dart';

const schoolBellSoundUrl = 'https://kirpalsagaracademy.github.io/school-bell/'
    'assets/assets/school_bell_sound.mp3';

class SchoolBellApp extends StatelessWidget {
  const SchoolBellApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KSA School Bell',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => BellBloc(),
        child: BlocProvider(
          create: (context) => ScheduleBloc(bellBloc: context.read<BellBloc>()),
          child: const HomePage(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (browser.isChrome) {
      Future.delayed(Duration.zero, () => _showAudioPermissionDialog(context));
    }
    final bellBloc = context.read<BellBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('KSA School Bell'),
      ),
      body: BlocListener<BellBloc, BellState>(
        bloc: bellBloc,
        listener: (context, state) async {
          if (state is BellRinging) {
            AudioPlayer audioPlayer = AudioPlayer();
            await audioPlayer.play(schoolBellSoundUrl);
            bellBloc.add(BellMuted());
          }
        },
        child: Container(
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                  width: 500,
                  child: TimerCard(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAudioPermissionDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Information for Chrome users'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints.loose(const Size(500, 500)),
                  child: const Text(
                    'This app will automatically play a school bell '
                    'sound at the start and end of each school period in the '
                    'Kirpal Sagar Academy.',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
