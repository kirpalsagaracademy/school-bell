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
        child: Timer(),
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
    return Container(
        width: 600,
        height: 600,
        decoration: BoxDecoration(
          border: Border.all(width: 5.0),
          borderRadius: BorderRadius.all(
              Radius.circular(35.0) //                 <--- border radius here
              ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
              Radius.circular(30.0) //                 <--- border radius here
              ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey,
                  child: Center(
                    child: Text("1st Period"),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.yellow,
                  child: Center(
                    child: Text("00:02:01"),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class CountdownDisplay extends StatelessWidget {
  final CountdownDisplayModel _countdownDisplayModel;

  CountdownDisplay({Key? key, required int countdownInSec})
      : _countdownDisplayModel = CountdownDisplayModel(countdownInSec: countdownInSec),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [],
      )
    ],);
  }
}
