library timer_stop_watch;

import 'dart:async';


class TimerStopWatch {
  //The map that manages timers.
  final Map<dynamic, _Timer> _timerMap = {};

  //The map that manages stopwatch.
  final Map<dynamic, _Stopwatch> _stopwatchMap= {};

  //Create an available stopwatch.
  //You can use the key to create a distinguishable stopwatch.
  //-------------------------------
  //- If "timeFormat" is not used, only seconds will be returned.
  //- You can change it freely.
  //- or
  //- use "timeFormat", it will be returned in the desired time format.
  //- "timeFormat" example > hour : 1, minute : 10, seconds : 5
  //- timeFormat "hh-mm-ss" return 01-10-05
  //- timeFormat "HH-MM-SS" return 1-10-5
  //- timeFormat "HH-mm-ss" return 1-10-05
  //- timeFormat "hh:mm-ss" return 01:10:05
  //- timeFormat "HHommoSS" return 1o10o5
  //-------------------------------
  Stream<String> setStopwatch({
    String? timeFormat,
    //"start"
    //True when starting at the same time as creating
    bool start = false,
    String? key,
  }) async* {
    if(key == null) {
      _stopwatchMap[_stopwatchMap.length] = _Stopwatch(timeFormat: timeFormat == null ? "" : timeFormat, start: start);
      yield* _stopwatchMap[_stopwatchMap.length-1]!.setStopwatch();
    }

    _stopwatchMap[key] = _Stopwatch(timeFormat: timeFormat == null ? "" : timeFormat, start: start);
    yield* _stopwatchMap[key]!.setStopwatch();
  }

  //Create an available timer.
  //You can use the key to create a distinguishable timer.
  //-------------------------------
  //- If "timeFormat" is not used, only seconds will be returned.
  //- You can change it freely.
  //- or
  //- use "timeFormat", it will be returned in the desired time format.
  //- "timeFormat" example > hour : 1, minute : 10, seconds : 5
  //- timeFormat "hh-mm-ss" return 01-10-05
  //- timeFormat "HH-MM-SS" return 1-10-5
  //- timeFormat "HH-mm-ss" return 1-10-05
  //- timeFormat "hh:mm-ss" return 01:10:05
  //- timeFormat "HHommoSS" return 1o10o5
  //-------------------------------
  Stream<String> setTimer({
    int hour = 0,
    int minute = 0,
    int seconds = 0,
    String? timeFormat,
    //"start"
    //True when starting at the same time as creating
    bool start = false,
    String? key,
}) async* {
    if(hour < 0 || minute < 0 || seconds <0) {
      yield throw ArgumentError("Negative numbers are not allowed.");
    }

    if(key == null) {
      _timerMap[_timerMap.length] = _Timer(hour: hour, minute: minute, seconds: seconds, timeFormat: timeFormat == null ? "" : timeFormat, start: start);
      yield* _timerMap[_timerMap.length-1]!.setTimer();
    }

    _timerMap[key] = _Timer(hour: hour, minute: minute, seconds: seconds, timeFormat: timeFormat == null ? "" : timeFormat, start: start);
    yield* _timerMap[key]!.setTimer();
  }


  //Start the timer.
  //If it contains a key, it starts a timer for that key.
  void startTimer({String? key}) {
    if(key != null) {
      _timerMap[key]?.startTimer();
      return;
    }
    _timerMap.forEach((key, value) { value.startTimer();});
  }

  //Pause the timer.
  //If it contains a key, pause the timer for that key.
  void pauseTimer({String? key}) {
    if(key != null) {
      _timerMap[key]?.pause();
      return;
    }
    _timerMap.forEach((key, value) { value.pause();});
  }

  //Reset the timer.
  //If it contains a key, reset the timer for that key.
  void resetTimer({String? key}) {
    if(key != null) {
      _timerMap[key]?.reset();
      return;
    }
    _timerMap.forEach((key, value) { value.reset();});
  }

  //Start the stopwatch.
  //If it contains a key, it starts a stopwatch for that key.
  void startStopwatch({String? key}) {
    if(key != null) {
      _stopwatchMap[key]?.startStopwatch();
      return;
    }
    _stopwatchMap.forEach((key, value) { value.startStopwatch();});
  }

  //Pause the stopwatch.
  //If it contains a key, pause the stopwatch for that key.
  void pauseStopwatch({String? key}) {
    if(key != null) {
      _stopwatchMap[key]?.pause();
      return;
    }
    _stopwatchMap.forEach((key, value) { value.pause();});
  }

  //Reset the stopwatch.
  //If it contains a key, reset the stopwatch for that key.
  void resetStopwatch({String? key}) {
    if(key != null) {
      _stopwatchMap[key]?.reset();
      return;
    }
    _stopwatchMap.forEach((key, value) { value.reset();});
  }

  //It must be called.
  //Used to clean up streams in use.
  void dispose() {
    if(_timerMap.isNotEmpty) {
      _timerMap.forEach((key, value) {value.dispose();});
    }
    if(_stopwatchMap.isNotEmpty) {
      _stopwatchMap.forEach((key, value) {value.dispose();});
    }
  }
}

//Class to create timer objects
class _Timer {
  var hour;
  var minute;
  var seconds;
  String timeFormat;
  bool start;
  _Timer({required this.hour, required this.minute, required this.seconds, required this.timeFormat, required this.start});


  StreamSubscription? sub;
  StreamController streamController = StreamController();
  bool? hh;
  String hM = "";
  bool? mm;
  String mS = "";
  bool? ss;

  int _hour = 0;
  int _minute = 0;
  int _seconds = 0;
  int _totalSeconds = 0;


  Stream<String> setTimer() async* {
    _hour = hour;
    _minute = minute;
    _seconds = seconds;

    preview();

    if(timeFormat != "") {
          if(hh != null) {
            sub = Stream.periodic(const Duration(seconds: 1), (_) {
              if (--_seconds < 0) {
                _seconds = 59;
                if (--_minute < 0) {
                  _minute = 59;
                  if (--_hour < 0) {
                    sub!.pause();
                    return "${hh! ? hour.toString().padLeft(2, "0") : hour}$hM${mm! ? minute.toString().padLeft(2, "0") : minute}$mS${ss! ? seconds.toString().padLeft(2, "0") : seconds}";
                  }
                }
              }
              return "${hh! ? _hour.toString().padLeft(2, "0") : _hour.toString()}$hM${mm! ? _minute.toString().padLeft(2, "0") : _minute.toString()}$mS${ss! ? _seconds.toString().padLeft(2, "0") : _seconds.toString()}";
            }).listen((streamController.sink.add), onError: (error) {
              streamController.sink.addError(error);
            });
          } else if(mm != null) {
            sub = Stream.periodic(const Duration(seconds: 1), (_) {
              if (--_seconds < 0) {
                _seconds = 59;
                if (--_minute < 0) {
                  _minute = 59;
                  if (--_hour < 0) {
                    sub!.pause();
                    return "${mm! ? minute.toString().padLeft(2, "0") : minute.toString()}$mS${ss! ? seconds.toString().padLeft(2, "0") : seconds.toString()}";
                  }
                }
              }
              return "${mm! ? _minute.toString().padLeft(2, "0") : _minute.toString()}$mS${ss! ? _seconds.toString().padLeft(2, "0") : _seconds.toString()}";
            }).listen((streamController.sink.add), onError: (error) {
              streamController.sink.addError(error);
            });
          } else {

            sub = Stream.periodic(const Duration(seconds: 1), (_) {
              if (--_seconds < 0) {
                _seconds = 59;
                if (--_minute < 0) {
                  _minute = 59;
                  if (--_hour < 0) {
                    sub!.pause();
                    return "${ss! ? seconds.toString().padLeft(2, "0") : seconds.toString()}";
                  }
                }
              }
              return "${ss! ? _seconds.toString().padLeft(2, "0") : _seconds.toString()}";
            }).listen((streamController.sink.add), onError: (error) {
              streamController.sink.addError(error);
            });
      }
    } else {
      _totalSeconds = totalSecondsAdd();

      sub = Stream.periodic(const Duration(seconds: 1), (_) {
        if (--_totalSeconds < 0) {
          sub!.pause();
          return totalSecondsAdd().toString();
        }
        return _totalSeconds.toString();
      }).listen((streamController.sink.add), onError: (error) {
        streamController.sink.addError(error);
      });
    }

    if(!start) {
      pause();
    }

    yield* streamController.stream.map((event) => event);
  }


  void pause() {
    if(sub != null && !sub!.isPaused) {
      sub!.pause();
    }
  }

  void startTimer() {
    if(_hour < 0) return;
    if(_totalSeconds < 0) return;
    if(sub == null || !sub!.isPaused) return;
    sub!.resume();
  }

  void reset() {
    _hour = hour;
    _minute = minute;
    _seconds = seconds;
    _totalSeconds = totalSecondsAdd();
    pause();
    preview();
  }


  void dispose() {
    streamController.close();
    sub?.cancel();
  }

  void preview() {
    if(timeFormat != "") {
      validateTimeFormat();
      formatExtraction();
          if(hh != null) {
            streamController.sink.add(
                "${hh! ? _hour.toString().padLeft(2, "0") : _hour.toString()}$hM${mm! ? _minute.toString().padLeft(2, "0") : _minute.toString()}$mS${ss! ? _seconds.toString().padLeft(2, "0") : _seconds.toString()}"
            );

          } else if(mm != null) {
            streamController.sink.add(
                "${mm! ? _minute.toString().padLeft(2, "0") : _minute.toString()}$mS${ss! ? _seconds.toString().padLeft(2, "0") : _seconds.toString()}"
            );


          } else {
            streamController.sink.add(
                "${ss! ? _seconds.toString().padLeft(2, "0") : _seconds.toString()}"
            );

          }

    } else {
      streamController.sink.add(totalSecondsAdd().toString());
    }
  }


  //Validate and extract the entered TimeFormat.
  void formatExtraction() {
    final upperFormat = timeFormat.trim().toUpperCase();
    final Map<int, String> map = {};
    final format = timeFormat.trim();

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
          ? {
        hh = null,
        mm = null,
        ss = sortedMap[0].value == "ss" ? true : false,
        hM = "",
        mS = ""
      }
          : throw ArgumentError("Only seconds are allowed.");
    } else if (sortedMap.length == 2) {
      sortedMap[0].value.toUpperCase() != "MM" ||
          sortedMap[1].value.toUpperCase() != "SS"
          ? throw ArgumentError("You must enter a valid time format. ex) mm:ss")
          : {
        hh = null,
        mm = sortedMap[0].value == "mm" ? true : false,
        ss = sortedMap[1].value == "ss" ? true : false,
        hM = "",
        mS = format.substring(sortedMap[0].key + 2, sortedMap[1].key),
      };
    } else if (sortedMap.length == 3) {
      sortedMap[0].value.toUpperCase() != "HH" ||
          sortedMap[1].value.toUpperCase() != "MM" ||
          sortedMap[2].value.toUpperCase() != "SS"
          ? throw ArgumentError(
          "You must enter a valid time format. ex) hh:mm:ss")
          : {
        hh = sortedMap[0].value == "hh" ? true : false,
        mm = sortedMap[1].value == "mm" ? true : false,
        ss = sortedMap[2].value == "ss" ? true : false,
        hM = format.substring(sortedMap[0].key + 2, sortedMap[1].key),
        mS = format.substring(sortedMap[1].key + 2, sortedMap[2].key),
      };
    } else {
      throw ArgumentError("You must enter a valid time format. ex) hh:mm:ss");
    }
  }


  //Returns the time entered by the user in seconds.
  int totalSecondsAdd() {
    int totalSeconds = (_hour * 3600) + (_minute * 60) + _seconds;
    if (totalSeconds > 24 * 3600) {
      throw ArgumentError("You cannot enter a value that exceeds 24 hours.");
    }
    return totalSeconds;
  }


  //TimeFormat has some restrictions.
  //Verify that TimeFormat is correct.
  void validateTimeFormat() {
    if (timeFormat == "") {
      throw ArgumentError("You must enter a time format. ex) hh:mm:ss");
    }
    validateRange("hour", hour, 0, 24);
    validateRange("minute", minute, 0, 60);
    validateRange("seconds", seconds, 0, 60);

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
  void validateRange(String name, int value, int minValue, int maxValue) {
    if (value < minValue || value > maxValue) {
      throw ArgumentError('$name must be between $minValue and $maxValue');
    }
  }
}

//Class to create stopwatch objects
class _Stopwatch {
  String timeFormat;
  bool start;
  _Stopwatch({required this.timeFormat, required this.start});

  StreamSubscription? sub;
  StreamController streamController = StreamController();
  bool? hh;
  String hM = "";
  bool? mm;
  String mS = "";
  bool? ss;
  int hour = 0;
  int minute = 0;
  int seconds = 0;

  Stream<String> setStopwatch() async*{
    preview();

    if(timeFormat != "") {
      if(hh != null) {
        sub = Stream.periodic(const Duration(seconds: 1), (_) {
          if (++seconds > 59) {
            seconds = 0;
            if (++minute > 59) {
              seconds = 0;
              if (++hour > 23) {
                sub!.pause();
                return "${hh! ? "0".padLeft(2, "0") : "0"}$hM${mm! ? "0".padLeft(2, "0") : "0"}$mS${ss! ? "0".padLeft(2, "0") : "0"}";
              }
            }
          }
          return "${hh! ? hour.toString().padLeft(2, "0") : hour.toString()}$hM${mm! ? minute.toString().padLeft(2, "0") : minute.toString()}$mS${ss! ? seconds.toString().padLeft(2, "0") : seconds.toString()}";
        }).listen((streamController.sink.add), onError: (error) {
          streamController.sink.addError(error);
        });
      } else if(mm != null) {
        sub = Stream.periodic(const Duration(seconds: 1), (_) {
          if (++seconds > 59) {
            seconds = 0;
            if (++minute > 59) {
              seconds = 0;
              if (++hour > 23) {
                sub!.pause();
                return "${mm! ? "0".padLeft(2, "0") : "0"}$mS${ss! ? "0".padLeft(2, "0") : "0"}";
              }
            }
          }
          return "${mm! ? minute.toString().padLeft(2, "0") : minute.toString()}$mS${ss! ? seconds.toString().padLeft(2, "0") : seconds.toString()}";
        }).listen((streamController.sink.add), onError: (error) {
          streamController.sink.addError(error);
        });
      } else {

        sub = Stream.periodic(const Duration(seconds: 1), (_) {
          if (++seconds > 59) {
            seconds = 0;
            if (++minute > 59) {
              seconds = 0;
              if (++hour > 23) {
                sub!.pause();
                return "${ss! ? "0".padLeft(2, "0") : "0"}";
              }
            }
          }
          return "${ss! ? seconds.toString().padLeft(2, "0") : seconds.toString()}";
        }).listen((streamController.sink.add), onError: (error) {
          streamController.sink.addError(error);
        });
      }
    } else {

      sub = Stream.periodic(const Duration(seconds: 1), (_) {
        if (++seconds > 86400 ) {
          sub!.pause();
          return "0";
        }
        return seconds.toString();
      }).listen((streamController.sink.add), onError: (error) {
        streamController.sink.addError(error);
      });
    }

    if(!start) {
      pause();
    }
    yield* streamController.stream.map((event) => event);
  }

  void pause() {
    if(sub != null && !sub!.isPaused) {
      sub!.pause();
    }
  }

  void startStopwatch() {
    if(seconds > 86400 ) return;
    if(sub == null || !sub!.isPaused) return;
    sub!.resume();
  }

  void reset() {
     hour = 0;
    minute = 0;
    seconds = 0;
    pause();
    preview();
  }


  void dispose() {
    streamController.close();
    sub?.cancel();
  }

  void preview() {
    if(timeFormat != "") {
      formatExtraction();

      if(hh != null) {
        streamController.sink.add(
            "${hh! ? hour.toString().padLeft(2, "0") : hour.toString()}$hM${mm! ? minute.toString().padLeft(2, "0") : minute.toString()}$mS${ss! ? seconds.toString().padLeft(2, "0") : seconds.toString()}"
        );

      } else if(mm != null) {
        streamController.sink.add(
            "${mm! ? minute.toString().padLeft(2, "0") : minute.toString()}$mS${ss! ? seconds.toString().padLeft(2, "0") : seconds.toString()}"
        );


      } else {
        streamController.sink.add(
            "${ss! ? seconds.toString().padLeft(2, "0") : seconds.toString()}"
        );

      }

    } else {
      streamController.sink.add(seconds.toString());
    }
  }

  //Validate and extract the entered TimeFormat.
  void formatExtraction() {
    final upperFormat = timeFormat.trim().toUpperCase();
    final Map<int, String> map = {};
    final format = timeFormat.trim();

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
          ? {
        hh = null,
        mm = null,
        ss = sortedMap[0].value == "ss" ? true : false,
        hM = "",
        mS = ""
      }
          : throw ArgumentError("Only seconds are allowed.");
    } else if (sortedMap.length == 2) {
      sortedMap[0].value.toUpperCase() != "MM" ||
          sortedMap[1].value.toUpperCase() != "SS"
          ? throw ArgumentError("You must enter a valid time format. ex) mm:ss")
          : {
        hh = null,
        mm = sortedMap[0].value == "mm" ? true : false,
        ss = sortedMap[1].value == "ss" ? true : false,
        hM = "",
        mS = format.substring(sortedMap[0].key + 2, sortedMap[1].key),
      };
    } else if (sortedMap.length == 3) {
      sortedMap[0].value.toUpperCase() != "HH" ||
          sortedMap[1].value.toUpperCase() != "MM" ||
          sortedMap[2].value.toUpperCase() != "SS"
          ? throw ArgumentError(
          "You must enter a valid time format. ex) hh:mm:ss")
          : {
        hh = sortedMap[0].value == "hh" ? true : false,
        mm = sortedMap[1].value == "mm" ? true : false,
        ss = sortedMap[2].value == "ss" ? true : false,
        hM = format.substring(sortedMap[0].key + 2, sortedMap[1].key),
        mS = format.substring(sortedMap[1].key + 2, sortedMap[2].key),
      };
    } else {
      throw ArgumentError("You must enter a valid time format. ex) hh:mm:ss");
    }
  }
}

