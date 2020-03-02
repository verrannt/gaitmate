import 'package:flutter/material.dart';

class SensorModel extends ChangeNotifier {
  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<double> _geoLocationValues;

  List<double> get accelerometerValues => _accelerometerValues;
  List<double> get userAccelerometerValues => _userAccelerometerValues;
  List<double> get gyroscopeValues => _gyroscopeValues;
  List<double> get locationValues => _geoLocationValues;


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

