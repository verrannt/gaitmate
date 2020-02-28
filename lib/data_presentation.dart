import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'package:gaitmate/sensor_model.dart';


class DataPresentation extends StatefulWidget {
  @override
_DataPresentationState createState() => _DataPresentationState();
}

class _DataPresentationState extends State<DataPresentation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Text('Current Sensor Data',
              style: TextStyle(fontSize: 20, color: Colors.black87)
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Consumer<SensorModel>(
                builder: (context, sensors, child) {
                  final List<String> accelerometer = sensors._accelerometerValues
                      ?.map((double v) => v.toStringAsFixed(1))?.toList();
                  return Text('Accelerometer: $accelerometer');
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Consumer<SensorModel>(
                builder: (context, sensors, child) {
                  final List<String> userAccelerometer = sensors._userAccelerometerValues
                      ?.map((double v) => v.toStringAsFixed(1))?.toList();
                  return Text('UserAccelerometer: $userAccelerometer');
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Consumer<SensorModel>(
                builder: (context, sensors, child) {
                  final List<String> gyroscope = sensors._gyroscopeValues
                      ?.map((double v) => v.toStringAsFixed(1))?.toList();
                  return Text('Gyroscope: $gyroscope');
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Text('Current Location',
              style: TextStyle(fontSize: 20, color: Colors.black87)
          ),
        ),
        Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Consumer<SensorModel>(
                  builder: (context, sensors, child) {
                    final List<String> geoLocation = sensors._geoLocationValues
                        ?.map((double v) => v.toStringAsFixed(1))?.toList();
                    return Text('Geolocation: $geoLocation');
                  },
                ),
              ],
            ),
            padding: const EdgeInsets.only(top: 10.0, bottom: 20.0)
        ),
        Flexible(
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(37.7, -122.4),
              zoom: 1.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                // For example purposes. It is recommended to use
                // TileProvider with a caching and retry strategy, like
                // NetworkTileProvider or CachedNetworkTileProvider
                tileProvider: NonCachingNetworkTileProvider(),
              ),
              //MarkerLayerOptions(markers: null)
            ],
          ),
        ),
      ],
    );
  }
}
