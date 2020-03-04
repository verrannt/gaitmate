import 'package:flutter/material.dart';
import 'package:gaitmate/past_recordings.dart';
import 'package:gaitmate/models/sensor_recorder_model.dart';

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

