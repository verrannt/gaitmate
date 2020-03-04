import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class SensorRecorderModel extends ChangeNotifier {

  // Whether the app is in recording mode
  bool _isRecording = false;
  // The type of the current activity. None-type if not recording.
  String _activityType = '';
  // The current sensor data
  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<double> _geoLocationValues;
  // Recorded sensor data history
  List<List<List<double>>> _recordedData = [];

  bool get isRecording => _isRecording;
  String get activityType => _activityType;
  List<double> get accelerometerValues => _accelerometerValues;
  List<double> get userAccelerometerValues => _userAccelerometerValues;
  List<double> get gyroscopeValues => _gyroscopeValues;
  List<double> get locationValues => _geoLocationValues;

  Timer _timer;

  void startRecording(String activityType) {
    _isRecording = true;
    _activityType = activityType;
    _timer = Timer.periodic(Duration(milliseconds: 10), (Timer t) => saveToHistory());
    notifyListeners();
  }

  void saveToHistory() {
    _recordedData.add([
        _accelerometerValues,
        _userAccelerometerValues,
        _gyroscopeValues
    ]);
    print(_recordedData);
    print(DateTime.now());
    print('\n');
  }

  void stopRecording() {
    // Parse filename with activityType and timestemp
    final DateTime now = DateTime.now();
    final date = now.toString().split(' ')[0];
    final time = now.toString().split(' ')[1].split('.')[0];
    final filename = '${_activityType}_$date--$time.csv';
    safeRecordedData(filename);
    _isRecording = false;
    _activityType = '';
    _timer.cancel();
    notifyListeners();
  }

  void safeRecordedData(String filename) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory.path}/$filename');
    // Format sensor data as string
    String csv = const ListToCsvConverter().convert(_recordedData);
    await file.writeAsString(csv);
    print('Saved data as csv file $filename in ${directory.path}');
    // Reset cached recorded data list
    _recordedData = [];
    final dir = await getExternalStorageDirectory();
    print(dir.listSync(recursive: true, followLinks: false));
  }

  void setAccelerometerValues(List values) {
    _accelerometerValues = values;
    notifyListeners();
  }

  void setUserAccelerometerValues(List values) {
    _userAccelerometerValues = values;
    notifyListeners();
  }

  void setGyroscopeValues(List values) {
    _gyroscopeValues = values;
    notifyListeners();
  }

  void setLocationValues(List values) {
    _geoLocationValues = values;
    notifyListeners();
  }

}

