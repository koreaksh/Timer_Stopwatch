import 'package:flutter/material.dart';
import 'package:timer_stop_watch/timer_stop_watch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimerStopwatch',
      debugShowCheckedModeBanner: false,
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
  late Stream<String> _timer2;
  late Stream<String> _timer3;
  late Stream<String> _stopwatch1;
  late Stream<String> _stopwatch2;
  late Stream<String> _stopwatch3;

  @override
  void initState() {
    super.initState();
    _timer1 = _timerStopWatch.setTimer(hour: 1, minute: 1, seconds: 10, timeFormat: "hh:mm:ss", start: true);
    _timer2 = _timerStopWatch.setTimer(hour: 1, minute: 1, seconds: 10, start: true);
    _timer3 = _timerStopWatch.setTimer(hour: 1, minute: 1, seconds: 10, timeFormat: "hh:mm:ss", key: "timer3");

    _stopwatch1 = _timerStopWatch.setStopwatch(start: true, timeFormat: "hh:mm:ss");
    _stopwatch2 = _timerStopWatch.setStopwatch(start: true);
    _stopwatch3 = _timerStopWatch.setStopwatch(timeFormat: "hh:mm:ss", key: "stopwatch3");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text("Timer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Divider(thickness: 1),
                    StreamBuilder(
                        stream: _timer1,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data.toString());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return SizedBox();
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                    StreamBuilder(
                        stream: _timer2,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data.toString());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return SizedBox();
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                    SizedBox(height: 30),
                    StreamBuilder(
                        stream: _timer3,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data.toString());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return SizedBox();
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _timerStopWatch.startTimer(key: "timer3");
                          },
                          child: Text("start"),
                          style: ElevatedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.all(5))
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _timerStopWatch.pauseTimer(key: "timer3");
                            },
                            child: Text("pause"),
                            style: ElevatedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.all(5))
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _timerStopWatch.resetTimer(key: "timer3");
                            },
                            child: Text("reset"),
                            style: ElevatedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.all(5))
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: (){_timerStopWatch.startTimer();},
                        child: Text("all start")),
                    ElevatedButton(
                        onPressed: (){_timerStopWatch.pauseTimer();},
                        child: Text("all pause")),
                    ElevatedButton(
                        onPressed: (){_timerStopWatch.resetTimer();},
                        child: Text("all reset")),
                    Spacer(),
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 1,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      "Stopwatch",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    StreamBuilder(
                        stream: _stopwatch1,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data.toString());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return SizedBox();
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                    StreamBuilder(
                        stream: _stopwatch2,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data.toString());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return SizedBox();
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                    SizedBox(height: 30),
                    StreamBuilder(
                        stream: _stopwatch3,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data.toString());
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return SizedBox();
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              _timerStopWatch.startStopwatch(key: "stopwatch3");
                            },
                            child: Text("start"),
                            style: ElevatedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.all(5))
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _timerStopWatch.pauseStopwatch(key: "stopwatch3");
                            },
                            child: Text("pause"),
                            style: ElevatedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.all(5))
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _timerStopWatch.resetStopwatch(key: "stopwatch3");
                            },
                            child: Text("reset"),
                            style: ElevatedButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.all(5))
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: (){_timerStopWatch.startStopwatch();},
                        child: Text("all start")),
                    ElevatedButton(
                        onPressed: (){_timerStopWatch.pauseStopwatch();},
                        child: Text("all pause")),
                    ElevatedButton(
                        onPressed: (){_timerStopWatch.resetStopwatch();},
                        child: Text("all reset")),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
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
