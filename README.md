# timer_stop_watch

You can freely use a timer and a stopwatch.    

![1](https://user-images.githubusercontent.com/89300787/221377540-8c59e20e-0ee2-46ca-b097-e42385e312ea.gif)
  
## Installation

Add this to your package's pubspec.yaml file:

```
dependencies:
  timer_stop_watch:
```

## Use

```dart
import 'package:timer_stop_watch/timer_stop_watch.dart';  // Import timer_stop_watch

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _timerStopWatch = TimerStopWatch(); // Create timer_stop_watch instance.
  late Stream<String> _timer; // Create a timer variable.
  late Stream<String> _stopwatch; // Create a Stopwatch variable
  
  @override
  void initState() {
    super.initState();
    _timer = _timerStopWatch.setTimer(hour: 1, minute: 1, seconds: 10, timeFormat: "hh:mm:ss");  // Timer initialization
    _stopwatch = _timerStopWatch.setStopwatch(timeFormat: "hh:mm:ss");  // Stopwatch initialization
  }
  
  @override
  void dispose() {
    await _timerStopWatch.dispose();  // Need to call dispose function.
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    ...
  StreamBuilder(  // StreamBuilder must be used.
    stream: _timer,
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
    ...
  }
}
```
