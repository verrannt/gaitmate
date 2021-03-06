import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Own modules
import 'package:gaitmate/past_recordings.dart';
import 'package:gaitmate/models/sensor_recorder_model.dart';

class MyBottomBar extends StatefulWidget {
  @override
  _MyBottomBarState createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {

  List<String> _activityOptions = ['walking', 'running', 'cycling'];
  List<DropdownMenuItem<String>> _activityDropdownMenuItems = List();

  @override
  void initState() {
    for (String option in _activityOptions) {
      _activityDropdownMenuItems.add(
          DropdownMenuItem(
              value: option,
              child: Text(option, style: TextStyle(fontSize: 16.0))
          )
      );
    }
    super.initState();
  }

  void _launchPastRecordings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PastRecordingsPage()),
    );
  }

  void _confirmRecordingStart() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        String _selectedActivity = _activityDropdownMenuItems[0].value;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              heightFactor: 0.66,
              child: Container(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16.0),
                    topRight: const Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Start new recording?',
                      style: TextStyle(fontSize: 22)
                    ),
                    Text(
                      'To start a new activity recording, please select '
                      'an activity from below.',
                      style: TextStyle(fontSize: 16),
                    ),
                    DropdownButton(
                      value: _selectedActivity,
                      items: _activityDropdownMenuItems,
                      onChanged: (String selectedActivity) {
                        setState(() => _selectedActivity = selectedActivity);
                      },
                      isExpanded: true,
                      isDense: false,
                      itemHeight: 56.0,
                    ),
                    FlatButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(18.0),
                      splashColor: Colors.grey,
                      onPressed: () => _startRecording(_selectedActivity),
                      child: Text('Start Recording',
                        style: TextStyle(fontSize: 20.0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  void _startRecording(String selectedActivity) {
    // Activate recordingState of RecorderModel and set activity type
    Provider.of<SensorRecorderModel>(context, listen: false)
      .startRecording(selectedActivity);
    // Exit modal dialog
    Navigator.pop(context);
  }

  void _confirmRecordingStop() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => FractionallySizedBox(
        heightFactor: 0.66,
        child: Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(40),
              topRight: const Radius.circular(40),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Stop current recording?',
                style: TextStyle(fontSize: 22, color: Colors.black87)
              ),
              Text(
                'If you stop the current recording, it will be saved locally '
                'as .csv with the activity and current date-time as name.',
                style: TextStyle(fontSize: 16),
              ),
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(18.0),
                splashColor: Colors.grey,
                onPressed: _stopRecording,
                child: Text('Stop Recording',
                    style: TextStyle(fontSize: 20.0)),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _stopRecording() {
    // Todo
    // 1. save recording to storage
    // 2. show success dialog:
    //   a. show name of saved activity
    //   b. offer to go to past recordings
    Provider.of<SensorRecorderModel>(context, listen: false).stopRecording();
    // Exit modal dialog
    Navigator.pop(context);
  }

  Widget isNotRecordingBar() {
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
          onPressed: _confirmRecordingStart,
          child: Text('New Recording',
              style: TextStyle(fontSize: 20.0)),
        ),
      ]
    );
  }

  Widget isRecordingBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('Stop current recording:',
              style: TextStyle(fontSize: 18, color: Colors.black87)
          ),
        ),
        FlatButton(
          color: Colors.white,
          textColor: Colors.indigo,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(20.0),
          splashColor: Colors.indigo[50],
          onPressed: _confirmRecordingStop,
          child: Text('Stop',
              style: TextStyle(fontSize: 20.0)),
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SensorRecorderModel>(
      builder: (context, recorder, child) {
        // If recording, return different UI
        if (recorder.isRecording == false) {
          return isNotRecordingBar();
        } else {
          return isRecordingBar();
        }
      },
    );
  }
}

