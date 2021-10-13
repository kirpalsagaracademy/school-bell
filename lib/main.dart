import 'package:flutter/material.dart';
import 'package:school_bell/core/time.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'K.S.A. School Bell',
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
        title: const Text('K.S.A. School Bell'),
      ),
      body: Center(
        child: Container(
          width: 500,
          child: Timer(),
        ),
      ),
    );
  }
}

class Timer extends StatefulWidget {
  const Timer({Key? key}) : super(key: key);

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.doorbell),
              title: Text('Next ringing'),
              subtitle: Text(
                  'Countdown for the time until the next ringing of the school bell'),
            ),
            CountdownDisplay(countdownInSec: 100),
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
