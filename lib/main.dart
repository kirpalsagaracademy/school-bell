import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_indicator/progress_indicator.dart';
import 'package:school_bell/clock_bloc/clock_bloc.dart';
import 'package:school_bell/core/time.dart';
import 'package:school_bell/countdown_bloc/countdown_bloc.dart';
import 'package:school_bell/schedule_bloc/schedule_bloc.dart';

import 'bell_bloc/bell_bloc.dart';

const schoolBellSoundUrl = 'https://kirpalsagaracademy.github.io/school-bell/'
    'assets/assets/school_bell_sound.mp3';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kirpal Sagar Academy - School Bell',
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
    Future.delayed(Duration.zero, () => _showMyDialog(context));
    final bellBloc = context.read<BellBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirpal Sagar Academy - School Bell'),
      ),
      body: BlocListener<BellBloc, BellState>(
        bloc: bellBloc,
        listener: (context, state) {
          if (state is BellRinging) {
            AudioPlayer audioPlayer = AudioPlayer();
            audioPlayer.play(schoolBellSoundUrl);

            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text('Ring - ring - ring'),
              ),
            );
          }
        },
        child: Container(
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // SizedBox(
                //   width: 500,
                //   child: CurrentRoutineCard(),
                // ),
                // SizedBox(height: 30),
                SizedBox(
                  width: 500,
                  child: TimerCard(),
                ),
                // SizedBox(height: 30),
                // SizedBox(
                //   width: 500,
                //   child: CurrentTimeCard(),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
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

class CurrentRoutineCard extends StatelessWidget {
  const CurrentRoutineCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        var routine = state.currentRoutine;
        var routineIcon = routine.isSchoolPeriod ? Icons.school : Icons.home;
        return Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(routineIcon),
                  // leading: Icon(Icons.school),
                  title: const Text('Current routine'),
                ),
                Text(routine.name),
                BlocProvider(
                  create: (context) =>
                      ClockBloc(
                        clockRate: const Duration(
                          seconds: 5,
                        ),
                      ),
                  child: BlocBuilder<ClockBloc, ClockState>(
                    builder: (context, state) {
                      return BarProgress(
                        percentage: routine.progressPercentage(DateTime.now()),
                        color: Colors.black,
                        backColor: Colors.grey,
//                gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
                        showPercentage: false,
                        // textStyle: TextStyle(color: Colors.orange, fontSize: 70),
                        stroke: 20,
                        round: false,
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(routine.start.toString()),
                    Text(routine.end.toString()),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class CurrentTimeCard extends StatelessWidget {
  const CurrentTimeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              // leading: Icon(Icons.home),
              // leading: Icon(Icons.wb_sunny),
              // leading: Icon(Icons.ac_unit),
              title: Text('Current time'),
            ),
            BlocProvider(
              create: (context) =>
                  ClockBloc(
                    clockRate: const Duration(seconds: 10),
                  ),
              child: BlocBuilder<ClockBloc, ClockState>(
                builder: (context, state) {
                  return Text(DateTime.now().toFormattedString());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerCard extends StatelessWidget {
  const TimerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        print('Building countdown');
        return Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.alarm),
                  title: Text(
                      'Next school bell ringing: ${state.nextRinging.routine
                          .name}'),
                ),
                BlocProvider(
                  create: (context) =>
                      CountdownBloc(state.nextRinging.dateTime),
                  child: const CountdownDisplay(),
                ),
                Text(state.nextRinging.dateTime.toFormattedString()),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CountdownDisplay extends StatelessWidget {
  const CountdownDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountdownBloc, CountdownState>(
      builder: (context, state) {
        const digitStyle = TextStyle(fontSize: 50);
        const digitBoxWidth = 50 + 15.0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: digitBoxWidth,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(state.hours, style: digitStyle),
                  ),
                ),
                const Align(
                  child: Text('hours'),
                  alignment: Alignment.topRight,
                ),
              ],
            ),
            Column(
              children: const [
                Text(':', style: digitStyle),
                Text(''),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: digitBoxWidth,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(state.minutes, style: digitStyle),
                  ),
                ),
                const Text('minutes'),
              ],
            ),
            Column(
              children: const [
                Text(':', style: digitStyle),
                Text(''),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: digitBoxWidth,
                  child: Text(state.seconds, style: digitStyle),
                ),
                const Text('seconds'),
              ],
            ),
          ],
        );
      },
    );
  }
}
