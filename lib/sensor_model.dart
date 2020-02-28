import 'package:flutter/material.dart';

class SensorModel extends ChangeNotifier {
  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  List<double> _geoLocationValues;

  void setAccelerometerValues(List values) {
    _accelerometerValues = values;
    notifyListeners();
  }

  void setUserAccelerometerValues(List values) {
    _accelerometerValues = values;
    notifyListeners();
  }

  void setGyroscopeValues(List values) {
    _accelerometerValues = values;
    notifyListeners();
  }

  void setLocationValues(List values) {
    _geoLocationValues = values;
    notifyListeners();
  }
}

