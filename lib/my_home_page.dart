import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:gaitmate/my_bottom_bar.dart';
import 'package:gaitmate/sensor_model.dart';
import 'package:gaitmate/data_presentation.dart';

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<StreamSubscription<dynamic>> _streamSubscriptions =
    <StreamSubscription<dynamic>>[];

  var geolocator = Geolocator();
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10);

  @override
  Widget build(BuildContext context) {

    // Format sensor values to list of strings
    /*final List<String> accelerometer = _accelerometerValues
      ?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> gyroscope = _gyroscopeValues
      ?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> userAccelerometer = _userAccelerometerValues
      ?.map((double v) => v.toStringAsFixed(1))?.toList();
    final List<String> geoLocation = _geoLocationValues
      ?.map((double v) => v.toStringAsFixed(1))?.toList();*/

    return Scaffold(
      appBar: AppBar(
          leading: Icon(
              Icons.android),
          title: const Text('GaitMate')),
      body: Container(
        padding: EdgeInsets.all(0.0),
        child: Column(
            children: <Widget>[
              DataPresentation(),
              MyBottomBar(),
            ]
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose of sensor stream subscription
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    // Dispose of livemap
    // liveMapController.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Listeners for sensor changes
    _streamSubscriptions.add(
        accelerometerEvents.listen((AccelerometerEvent event) {
          Provider.of<SensorModel>(context).setAccelerometerValues(
              <double>[event.x, event.y, event.z]);
        })
    );
    _streamSubscriptions.add(
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
          Provider.of<SensorModel>(context).setUserAccelerometerValues(
              <double>[event.x, event.y, event.z]);
        })
    );
    _streamSubscriptions.add(
        gyroscopeEvents.listen((GyroscopeEvent event) {
          Provider.of<SensorModel>(context).setGyroscopeValues(
              <double>[event.x, event.y, event.z]);
          /*setState(() {
          _userAccelerometerValues = <double>[event.x, event.y, event.z];
        });*/
        })
    );
    // Listener for location change
    _streamSubscriptions.add(
        geolocator.getPositionStream(locationOptions).listen((Position position) {
          Provider.of<SensorModel>(context).setGyroscopeValues(
              <double>[position.latitude, position.longitude]);
        })
    );

    // mapController = MapController();
    // liveMapController = LiveMapController(mapController: mapController);
  }
}
