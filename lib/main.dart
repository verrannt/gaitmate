import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gaitmate/my_home_page.dart';
import 'package:gaitmate/sensor_model.dart';

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