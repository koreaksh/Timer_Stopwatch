library timer_stop_watch;

import 'dart:async';

class TimerStopWatch {
  final List<StreamSubscription> _subscriptions = [];
  final List<StreamController> _streamControllers = [];

  //startTimer
  //Use the timer freely by adding hours, minutes, and seconds.
  //You can use timeFormat to determine the type to be returned.
  //Double-digit fixation in lowercase  seconds = 4 => 04
  //Unfix with uppercase letters seconds = 4 => 4
  //You can freely set the delimiter between hours, minutes, and seconds.
  //TimeFormat Example
  //HH-MM-SS => 9-10-3
  //hh:mm:ss => 09:10:03
  //MMminutess => 10minute03
  //MMminuteSS => 10minute3
  //ss => 03
  //SS => 3
  //You can freely modify and use it.
  Stream<String> startTimer({
    int hour = 0,
    int minute = 0,
    int seconds = 0,
    String? timeFormat,
  }) async* {
    if (hour < 0 || minute < 0 || seconds < 0) {
      throw ArgumentError("Negative numbers are not allowed.");
    }

    print("실행됩니다1");

    StreamSubscription? sub;
    StreamController streamController = StreamController();
    var hourTime = hour;
    var minuteTime = minute;
    var secondsTime = seconds;
    var totalSeconds = 0;

    print("실행됩니다2");
    if (timeFormat != null) {
      _validateTimeFormat(
          hour: hour,
          minute: minute,
          seconds: seconds,
          timeFormat: timeFormat.trim());
      final List<String> result =
      _formatExtraction(timeFormat: timeFormat.trim());

      print("실행됩니다3");

      if (result.length == 1) {
        bool isData1 = result[0] == "ss" ? true : false;
        streamController.sink.add(isData1
            ? secondsTime.toString().padLeft(2, "0")
            : secondsTime.toString());
        print("실행됩니다4");
        sub = Stream.periodic(const Duration(seconds: 1), (_) {
          print("실행됩니다5");
          if (--secondsTime < 0) {
            secondsTime = 59;
            if (minuteTime < 0) {
              minuteTime = 59;
              if (--hourTime < 0) {
                sub!.cancel();
              }
            }
          }
          return isData1
              ? secondsTime.toString().padLeft(2, "0")
              : secondsTime.toString();
        }).listen((streamController.sink.add), onError: (error) {
          streamController.sink.addError(error);
        });
      } else if (result.length == 3) {
        print("실행됩니다6");
        bool isData1 = result[0] == "mm" ? true : false;
        String mS = result[1];
        bool isData2 = result[2] == "ss" ? true : false;

        streamController.sink.add("${isData1 ? minuteTime.toString().padLeft(2, "0") : minuteTime.toString()}$mS${isData2 ? secondsTime.toString().padLeft(2, "0") : secondsTime.toString()}");

        sub = Stream.periodic(const Duration(seconds: 1), (_) {
          print("실행됩니다7");
          if (--secondsTime < 0) {
            secondsTime = 59;
            if (--minuteTime < 0) {
              minuteTime = 59;
              if (--hourTime < 0) {
                sub!.cancel();
              }
            }
          }
          return "${isData1 ? minuteTime.toString().padLeft(2, "0") : minuteTime.toString()}$mS${isData2 ? secondsTime.toString().padLeft(2, "0") : secondsTime.toString()}";
        }).listen((streamController.sink.add), onError: (error) {
          streamController.sink.addError(error);
        });
      } else {
        print("실행됩니다8");
        bool isData1 = result[0] == "hh" ? true : false;
        String hM = result[1];
        bool isData2 = result[2] == "mm" ? true : false;
        String mS = result[3];
        bool isData3 = result[4] == "ss" ? true : false;

        streamController.sink.add(
            "${isData1 ? hourTime.toString().padLeft(2, "0") : hourTime.toString()}$hM${isData2 ? minuteTime.toString().padLeft(2, "0") : minuteTime.toString()}$mS${isData3 ? secondsTime.toString().padLeft(2, "0") : secondsTime.toString()}"
        );

        sub = Stream.periodic(const Duration(seconds: 1), (_) {
          print("실행됩니다9");
          if (--secondsTime < 0) {
            secondsTime = 59;
            if (--minuteTime < 0) {
              minuteTime = 59;
              if (--hourTime < 0) {
                sub!.cancel();
              }
            }
          }
          return "${isData1 ? hourTime.toString().padLeft(2, "0") : hourTime.toString()}$hM${isData2 ? minuteTime.toString().padLeft(2, "0") : minuteTime.toString()}$mS${isData3 ? secondsTime.toString().padLeft(2, "0") : secondsTime.toString()}";
        }).listen((streamController.sink.add), onError: (error) {
          streamController.sink.addError(error);
        });
      }
    } else {
      print("실행됩니다10");
      totalSeconds =
          _totalSecondsAdd(hour: hour, minute: minute, seconds: seconds);
      _validateSecondsInRange(totalSeconds: totalSeconds);

      sub = Stream.periodic(const Duration(seconds: 1), (_) {
        print("실행됩니다11");
        if (totalSeconds <= 0) {
          sub!.cancel();
        }
        totalSeconds--;
        return totalSeconds.toString();
      }).listen((streamController.sink.add), onError: (error) {
        streamController.sink.addError(error);
      });
    }
    _subscriptions.add(sub);
    _streamControllers.add(streamController);
    yield* streamController.stream.map((event) => event);
  }


  //You cannot set a time that exceeds 24 hours.
  //Verification function for entered time
  void _validateSecondsInRange({required int totalSeconds}) {
    if (totalSeconds >= 24 * 3600) {
      throw ArgumentError("You cannot enter a value that exceeds 24 hours.");
    }
  }


  //TimeFormat has some restrictions.
  //Verify that TimeFormat is correct.
  void _validateTimeFormat(
      {required int hour,
        required int minute,
        required int seconds,
        required String timeFormat}) {
    if (timeFormat == "") {
      throw ArgumentError("You must enter a time format. ex) hh:mm:ss");
    }
    _validateRange("hour", hour, 0, 24);
    _validateRange("minute", minute, 0, 60);
    _validateRange("seconds", seconds, 0, 60);

    if (hour == 24 && (minute > 0 || seconds > 0)) {
      throw ArgumentError(
          "TimeFormat ranges from hour:0 to 24, minute:0 to 60, seconds:0 to 60, and cannot exceed 24 hours.");
    } else if (minute == 60 && seconds > 0) {
      throw ArgumentError(
          "TimeFormat ranges from hour:0 to 24, minute:0 to 60, seconds:0 to 60, and cannot exceed 24 hours.");
    }
  }


  //TimeFormat has a time limit.
  //Verify that the time setting is correct.
  void _validateRange(String name, int value, int minValue, int maxValue) {
    if (value < minValue || value > maxValue) {
      throw ArgumentError('$name must be between $minValue and $maxValue');
    }
  }

  //Returns the time entered by the user in seconds.
  int _totalSecondsAdd(
      {required int hour, required int minute, required int seconds}) {
    int totalSeconds = (hour * 3600) + (minute * 60) + seconds;
    return totalSeconds;
  }


  //Validate and extract the entered TimeFormat.
  List<String> _formatExtraction({required String timeFormat}) {
    final upperFormat = timeFormat.toUpperCase();
    final Map<int, String> map = {};
    final List<String> result = [];
    final format = timeFormat;

    if (upperFormat.indexOf("HH") != upperFormat.lastIndexOf("HH")) {
      throw ArgumentError("You must enter a valid time format. ex) hh:mm:ss");
    } else if (upperFormat.indexOf("MM") != upperFormat.lastIndexOf("MM")) {
      throw ArgumentError("You must enter a valid time format. ex) hh:mm:ss");
    } else if (upperFormat.indexOf("SS") != upperFormat.lastIndexOf("SS")) {
      throw ArgumentError("You must enter a valid time format. ex) hh:mm:ss");
    }

    map[format.indexOf("HH")] = "HH";
    map[format.indexOf("hh")] = "hh";
    map[format.indexOf("MM")] = "MM";
    map[format.indexOf("mm")] = "mm";
    map[format.indexOf("SS")] = "SS";
    map[format.indexOf("ss")] = "ss";

    List<MapEntry<int, String>> sortedMap = map.entries
        .where((entry) => entry.key >= 0)
        .toList()
      ..sort((entry1, entry2) => entry1.key.compareTo(entry2.key));

    if (sortedMap.isEmpty) {
      throw ArgumentError("You must enter a valid time format. ex) hh:mm:ss");
    }

    if (sortedMap.length == 1) {
      sortedMap[0].value.toUpperCase() == "SS"
          ? result.add(sortedMap[0].value)
          : throw ArgumentError("Only seconds are allowed.");
    } else if (sortedMap.length == 2) {
      sortedMap[0].value.toUpperCase() != "MM" ||
          sortedMap[1].value.toUpperCase() != "SS"
          ? throw ArgumentError("You must enter a valid time format. ex) mm:ss")
          : result.add(sortedMap[0].value);
      result.add(format.substring(sortedMap[0].key + 2, sortedMap[1].key));
      result.add(sortedMap[1].value);
    } else if (sortedMap.length == 3) {
      sortedMap[0].value.toUpperCase() != "HH" ||
          sortedMap[1].value.toUpperCase() != "MM" ||
          sortedMap[2].value.toUpperCase() != "SS"
          ? throw ArgumentError(
          "You must enter a valid time format. ex) hh:mm:ss")
          : result.add(sortedMap[0].value);
      result.add(format.substring(sortedMap[0].key + 2, sortedMap[1].key));
      result.add(sortedMap[1].value);
      result.add(format.substring(sortedMap[1].key + 2, sortedMap[2].key));
      result.add(sortedMap[2].value);
    } else {
      throw ArgumentError("You must enter a valid time format. ex) hh:mm:ss");
    }

    return result;
  }


  //It must be called.
  //Used to clean up streams in use.
  void dispose() {
    if (_subscriptions.isEmpty) {
      for (var streamController in _streamControllers) {
        streamController.close();
      }
      return;
    }
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    for (var streamController in _streamControllers) {
      streamController.close();
    }
  }
}
