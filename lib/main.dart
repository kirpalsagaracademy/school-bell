import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_indicator/progress_indicator.dart';
import 'package:school_bell/core/time.dart';
import 'package:school_bell/countdown_bloc/countdown_bloc.dart';
import 'package:school_bell/schedule_bloc/schedule_bloc.dart';

import 'bell_bloc/bell_bloc.dart';

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
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ScheduleBloc>(
            create: (BuildContext context) => ScheduleBloc(),
          ),
          BlocProvider<BellBloc>(
            create: (BuildContext context) => BellBloc(),
          ),
        ],
        child: const HomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirpal Sagar Academy - School Bell'),
      ),
      body: Container(
        color: Colors.grey[300],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 500,
                child: CurrentPeriodCard(),
              ),
              SizedBox(height: 30),
              Container(
                width: 500,
                child: TimerCard(),
              ),
              SizedBox(height: 30),
              Container(
                width: 500,
                child: CurrentTimeCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentPeriodCard extends StatelessWidget {
  const CurrentPeriodCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.home),
              // leading: Icon(Icons.school),
              title: Text('Current routine'),
            ),
            Text('Morning tea'),
            Container(
              //width: 100,
              child: BarProgress(
                percentage: 30.0,
                color: Colors.black,
                backColor: Colors.grey,
//                gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
                showPercentage: false,
                // textStyle: TextStyle(color: Colors.orange, fontSize: 70),
                stroke: 20,
                round: false,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('8:10 a.m.'), Text('8:50 a.m.')],
            )
          ],
        ),
      ),
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
              leading: Icon(Icons.ac_unit),
              title: Text('Current time'),
            ),
            Text('Wednesday, 12-10-2021, 8:40 p.m.'),
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
        print("Building countdown");
        return Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.alarm),
                  title: Text('Next school bell ringing'),
                ),
                BlocProvider(
                  create: (context) => CountdownBloc(state.nextRinging.dateTime),
                  child: const CountdownDisplay(),
                ),
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
        return Row(
          children: [
            Column(
              children: [
                Text(state.hours),
                const Text('hours'),
              ],
            ),
            Column(
              children: [Align(child: Text(':'))],
            ),
            Column(
              children: [
                Text(state.minutes),
                const Text('minutes'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [Text(':')],
            ),
            Column(
              children: [
                Text(state.seconds),
                const Text('seconds'),
              ],
            ),
          ],
        );
      },
    );
  }
}
