import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gaitmate/my_home_page.dart';
import 'package:gaitmate/models/sensor_recorder_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SensorRecorderModel(),
      child: MaterialApp(
        title: 'GaitMate',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          primaryColor: Colors.indigo[500]),
        home: MyHomePage(title: 'GaitMate')),
    ),
  );
}

