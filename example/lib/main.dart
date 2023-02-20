import 'package:flutter/material.dart';
import 'package:timer_stop_watch/timer_stop_watch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimerStopwatch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final _timerStopWatch = TimerStopWatch();
  late Stream<String> _timer1;

  @override
  void initState() {
    super.initState();
    _timer1 = _timerStopWatch.setTimer(hour: 1, minute: 1, seconds: 10, timeFormat: "hh-mm-ss");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(
          stream: _timer1,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.toString());
            } else if (snapshot.hasError) {
              (error) => print(error);
              return SizedBox();
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timerStopWatch.dispose();
    super.dispose();
  }
}
