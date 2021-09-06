import 'dart:async';

import 'package:apicall/parser.dart';
import 'package:apicall/services/apiCall.dart';
import 'package:apicall/services/db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Timer.periodic(Duration(seconds: 10), (Timer timer) async {
    List<dynamic> jsonData = await getApiResponse();
    jsonData.forEach((element) async {
      if (element["uuid"] != null && element["minorID"] != null) {
        var test =
            Uuid(uid: element["uuid"], deviceId: element["minorID"].toString());
        var connections = test.parseString();
        if (connections != null)
          await makeContacts(element["minorID"].toString(), connections);
      }
    });
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'dd',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // getProfileByDeviceId('122');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
