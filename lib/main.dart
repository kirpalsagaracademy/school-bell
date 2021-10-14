import 'package:flutter/material.dart';
import 'package:progress_indicator/progress_indicator.dart';
import 'package:school_bell/core/time.dart';

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
      home: const HomePage(),
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
              title: Text('Current period'),
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

class TimerCard extends StatefulWidget {
  const TimerCard({Key? key}) : super(key: key);

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Next ringing'),
            ),
            CountdownDisplay(countdownInSec: 98),
          ],
        ),
      ),
    );
  }
}

class CountdownDisplay extends StatelessWidget {
  final CountdownDisplayModel _model;

  CountdownDisplay({Key? key, required int countdownInSec})
      : _model = CountdownDisplayModel(countdownInSec: countdownInSec),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(_model.hours),
            const Text('hours'),
          ],
        ),
        Column(
          children: [Align(child: Text(':'))],
        ),
        Column(
          children: [
            Text(_model.minutes),
            const Text('minutes'),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [Text(':')],
        ),
        Column(
          children: [
            Text(_model.seconds),
            const Text('seconds'),
          ],
        ),
      ],
    );
  }
}
