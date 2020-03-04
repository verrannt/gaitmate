import 'package:flutter_share/flutter_share.dart';

import 'package:flutter/material.dart';

class PastRecordingsPage extends StatefulWidget {
  @override
  _PastRecordingsPageState createState() => _PastRecordingsPageState();
}

class _PastRecordingsPageState extends State<PastRecordingsPage> {
  // Todo Implement file sharing
  /*Future<void> shareFile() async {
    await FlutterShare.shareFile(
      title: 'Example share',
      text: 'Example share text',
      filePath: docs[0] as String,
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Recordings'),
      ),
      body: Center(
      /*Center(
        child: RaisedButton(
          child: Text('Go back'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),*/
    );
  }
}
