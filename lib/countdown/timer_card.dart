import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_bell/schedule/schedule_bloc/schedule_bloc.dart';
import 'package:school_bell/time.dart';

import 'countdown_bloc/countdown_bloc.dart';

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
                    'Next school bell ringing: ${state.nextRinging.routine.name}',
                  ),
                ),
                BlocProvider(
                  key: ValueKey(state),
                  create: (context) {
                    return CountdownBloc(state.nextRinging.dateTime);
                  },
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