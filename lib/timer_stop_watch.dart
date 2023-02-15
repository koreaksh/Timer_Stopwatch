library timer_stop_watch;

import 'dart:async';

class TimerStopWatch {
  List<StreamSubscription> _subscriptions = [];
  List<StreamController> _streamControllers = [];

  Stream<String> startTimer({
    int hour = 0,
    int minute = 0,
    int seconds = 0,
    String? timeFormat,
  }) async* {
    if (hour < 0 || minute < 0 || seconds < 0)
      throw ArgumentError("Negative numbers are not allowed.");

    StreamSubscription? _sub;
    StreamController _streamController = StreamController();
    var _hourTime = hour;
    var _minuteTime = minute;
    var _secondsTime = seconds;
    var _totalSeconds = 0;

    if (timeFormat != null) {
      _validateTimeFormat(
          hour: hour,
          minute: minute,
          seconds: seconds,
          timeFormat: timeFormat.trim());
      final List<String> result =
      _formatExtraction(timeFormat: timeFormat.trim());

      if (result.length == 1) {
        bool isData1 = result[0] == "ss" ? true : false;
        _streamController.sink.add(isData1
            ? "${_secondsTime.toString().padLeft(2, "0")}"
            : _secondsTime.toString());
        _sub = Stream.periodic(Duration(seconds: 1), (_) {
          print("실행됩니다.1");
          if (--_secondsTime < 0) {
            _secondsTime = 59;
            if (--_minuteTime < 0) {
              _minuteTime = 59;
              if (--_hourTime < 0) {
                _sub!.cancel();
              }
            }
          }
          return isData1
              ? "${_secondsTime.toString().padLeft(2, "0")}"
              : _secondsTime.toString();
        }).listen((_streamController.sink.add), onError: (error) {
          _streamController.sink.addError(error);
        });
      } else if (result.length == 3) {
        bool isData1 = result[0] == "mm" ? true : false;
        String m_s = result[1];
        bool isData2 = result[2] == "ss" ? true : false;

        _streamController.sink.add("${isData1 ? _minuteTime.toString().padLeft(2, "0") : _minuteTime.toString()}${m_s}${isData2 ? _secondsTime.toString().padLeft(2, "0") : _secondsTime.toString()}");

        _sub = Stream.periodic(Duration(seconds: 1), (_) {
          print("실행됩니다.2");
          if (--_secondsTime < 0) {
            _secondsTime = 59;
            if (--_minuteTime < 0) {
              _minuteTime = 59;
              if (--_hourTime < 0) {
                _sub!.cancel();
              }
            }
          }
          return "${isData1 ? _minuteTime.toString().padLeft(2, "0") : _minuteTime.toString()}${m_s}${isData2 ? _secondsTime.toString().padLeft(2, "0") : _secondsTime.toString()}";
        }).listen((_streamController.sink.add), onError: (error) {
          _streamController.sink.addError(error);
        });
      } else {
        bool isData1 = result[0] == "hh" ? true : false;
        String h_m = result[1];
        bool isData2 = result[2] == "mm" ? true : false;
        String m_s = result[3];
        bool isData3 = result[4] == "ss" ? true : false;

        _streamController.sink.add(
            "${isData1 ? _hourTime.toString().padLeft(2, "0") : _hourTime.toString()}${h_m}${isData2 ? _minuteTime.toString().padLeft(2, "0") : _minuteTime.toString()}${m_s}${isData3 ? _secondsTime.toString().padLeft(2, "0") : _secondsTime.toString()}"
        );

        _sub = Stream.periodic(Duration(seconds: 1), (_) {
          print("실행됩니다.3");
          if (--_secondsTime < 0) {
            _secondsTime = 59;
            if (--_minuteTime < 0) {
              _minuteTime = 59;
              if (--_hourTime < 0) {
                _sub!.cancel();
              }
            }
          }
          return "${isData1 ? _hourTime.toString().padLeft(2, "0") : _hourTime.toString()}${h_m}${isData2 ? _minuteTime.toString().padLeft(2, "0") : _minuteTime.toString()}${m_s}${isData3 ? _secondsTime.toString().padLeft(2, "0") : _secondsTime.toString()}";
        }).listen((_streamController.sink.add), onError: (error) {
          _streamController.sink.addError(error);
        });
      }
    } else {
      _totalSeconds =
          _totalSecondsAdd(hour: hour, minute: minute, seconds: seconds);
      _validateSecondsInRange(totalSeconds: _totalSeconds);

      _sub = Stream.periodic(Duration(seconds: 1), (_) {
        print("실행됩니다.4");
        if (_totalSeconds <= 0) {
          _sub!.cancel();
        }
        _totalSeconds--;
        return _totalSeconds.toString();
      }).listen((_streamController.sink.add), onError: (error) {
        _streamController.sink.addError(error);
      });
    }
    _subscriptions.add(_sub);
    _streamControllers.add(_streamController);
    yield* _streamController.stream.map((event) => event);
  }
  void _validateSecondsInRange({required int totalSeconds}) {
    if (totalSeconds >= 24 * 3600) {
      throw ArgumentError("You cannot enter a value that exceeds 24 hours.");
    }
  }

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

  void _validateRange(String name, int value, int minValue, int maxValue) {
    if (value < minValue || value > maxValue) {
      throw ArgumentError('$name must be between $minValue and $maxValue');
    }
  }

  int _totalSecondsAdd(
      {required int hour, required int minute, required int seconds}) {
    int totalSeconds = (hour * 3600) + (minute * 60) + seconds;
    return totalSeconds;
  }

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

    if (sortedMap.isEmpty)
      throw ArgumentError("You must enter a valid time format. ex) hh:mm:ss");

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
