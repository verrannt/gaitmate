import 'dart:io';
import 'package:flutter_share/flutter_share.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class PastRecordingsPage extends StatefulWidget {
  @override
  _PastRecordingsPageState createState() => _PastRecordingsPageState();
}

class _PastRecordingsPageState extends State<PastRecordingsPage> {

  List<String> dirContents = [];

  @override
  void initState() {
    super.initState();
    getDirContents();
  }

  Future<void> getDirContents() async {
    final directory = await getExternalStorageDirectory();
    setState(() {
      dirContents = directory.listSync(recursive: true, followLinks: false)
          .map((FileSystemEntity f) => f.path.split("/").last).toList();
    });
  }

  // Todo Implement file sharing
  /*Future<void> shareFile() async {
    await FlutterShare.shareFile(
      title: 'Example share',
      text: 'Example share text',
      filePath: docs[0] as String,
    );
  }*/

  Widget buildListItem(BuildContext context, int index) {
    return new ListTile(
      title: Text(
        dirContents[index].split("_")[0],
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20
        )
      ),
      subtitle: Text(
        dirContents[index].split("_")[1],
        style: TextStyle(
            fontSize: 14
        )
      ),
      trailing: Icon(Icons.share),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Recordings'),
      ),
      body: new ListView.builder(
          itemCount: dirContents.length,
          itemBuilder: (BuildContext context, int index)
            => buildListItem(context, index)
      ),
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
