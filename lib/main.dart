import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
 import 'package:flutter_map/flutter_map.dart';
//import 'package:livemap/livemap.dart';
import 'package:latlong/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
//import 'package:location/location.dart';
import 'dart:async';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SensorModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GaitMate',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.indigo[500]),
      home: MyHomePage(title: 'GaitMate'));
  }
}

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
            MyBottomBar(
            ),
          ]
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose of sensor subscription
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

class MyBottomBar extends StatefulWidget {
  @override
  _MyBottomBarState createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {

  var _isRecording;

  void _selectItem(String name) {
    Navigator.pop(context);
  }

  void _launchPastRecordings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PastRecordingsPage()),
    );
  }

  void _stopRecording() {
    return null;
  }

  void _confirmRecording() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        color: Colors.white,
        height: 380,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(40),
              topRight: const Radius.circular(40),
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('Start new recording?',
                    style: TextStyle(fontSize: 22, color: Colors.black87)
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                    'To start a new activity recording, please select an activity from '
                    'below or type one in in the text field.\n\nNote: the name of the activty will '
                    'also be used for the filename.'
                ),
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(16.0),
                splashColor: Colors.grey,
                onPressed: _startRecording,
                child: Text('Start Recording',
                    style: TextStyle(fontSize: 20.0)),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    /*showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Start new recording?'),
        content: Text('Please select an activity and press Start to continue.'),
        actions: <Widget>[
          Row(

          ),
          Row
        ],
      ),
    );*/
  }


  void _startRecording() {
    // TODO
    // 1. record sensors into variable
    setState(() {
      _isRecording = true;
    });
    Navigator.pop(context);
  }

  void _endRecording() {
    // Todo
    // 1. save recording to storage
    // 2. show success dialog:
    //   a. show name of saved activity
    //   b. offer to go to past recordings
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FlatButton(
          color: Colors.white,
          textColor: Colors.indigo,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(20.0),
          splashColor: Colors.indigo[50],
          onPressed: _launchPastRecordings,
          child: Text('Past Recordings',
              style: TextStyle(fontSize: 20.0)),
        ),
        FlatButton(
          color: Colors.white,
          textColor: Colors.indigo,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(20.0),
          splashColor: Colors.indigo[50],
          onPressed: _confirmRecording,
          child: Text('New Recording',
              style: TextStyle(fontSize: 20.0)),
        )
      ],
    );
  }
}

class PastRecordingsPage extends StatefulWidget {
  @override
  _PastRecordingsPageState createState() => _PastRecordingsPageState();
}

class _PastRecordingsPageState extends State<PastRecordingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Recordings'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Go back'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );  }
}

/*
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have clicked the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/