import 'dart:async';

import 'package:apicall/models.dart/employee.dart';
import 'package:apicall/parser.dart';
import 'package:apicall/services/apiCall.dart';
import 'package:apicall/services/db.dart';
import 'package:apicall/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Timer.periodic(Duration(seconds: 10), (Timer timer) async {
  List<dynamic> jsonData = await getApiResponse();
  var count = 0;
  jsonData.forEach((element) async {
    // var difference = DateTime.parse(element["time"]).difference(DateTime.now());
    var difference = DateTime.now().difference(DateTime.parse(element["time"]));
    if (element["uuid"] != null &&
        element["minorID"] != null &&
        difference.inHours < 6) {
      count++;
      var test =
          Uuid(uid: element["uuid"], deviceId: element["minorID"].toString());
      var connections = test.parseString();
      if (connections != null)
        await makeContacts(element["minorID"].toString(), connections);
    }
  });
  print("count $count loopCount ${jsonData.length}");
  // });
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
      body: StreamBuilder<QuerySnapshot>(
          stream: getPeople(),
          builder: (context, snapshot) {
            List<Employee> employees = [];
            if (snapshot.connectionState == ConnectionState.active &&
                snapshot.hasData) {
              snapshot.data!.docs.map((DocumentSnapshot document) {
                var data = document.data() as Map<String, dynamic>;
                employees.add(Employee.fromJson(data));
              }).toList();
              return SingleChildScrollView(
                child: Column(
                  children: List.generate(employees.length, (index) {
                    var employee = employees[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.indigoAccent,
                        minVerticalPadding: 20,
                        trailing: SizedBox(
                          height: 60,
                        ),
                        title: Text(
                            "     ${employee.name}     ${employee.deviceId}     ${employee.contactHistory!.length}"),
                        subtitle: Column(
                          children: List.generate(
                              employee.contactHistory!.length, (index) {
                            var contact = employee.contactHistory![index];

                            return Center(child: Text(contact.contact));
                          }),
                        ),
                      ),
                    );
                    // return ContactTile(history: employee.contactHistory!,);
                  }),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
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
