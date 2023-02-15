import 'package:flutter/material.dart';
import 'package:timer_stop_watch/timer_stop_watch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder(stream: TimerStopWatch().startTimer(minute: 1, timeFormat: "hh:mm:ss"),builder: (context, snapshot) {
          if(snapshot.hasData) {
            return Text(snapshot.data.toString());
          } else if(snapshot.hasError) { (error) =>
            print(error);
            return SizedBox();
          } else {
            return CircularProgressIndicator();
          }
        }),
      ),
    );
  }

  @override
  void dispose() {
    _timerStopWatch.dispose();
    super.dispose();
  }
}
