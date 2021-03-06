import 'package:apicall/models.dart/employee.dart';
import 'package:apicall/parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference<Map<String, dynamic>> users =
    firestore.collection('Employees');

Future<Employee> getProfile(String uid) async {
  var docSnapshot = await users.doc(uid).get();
  var data = docSnapshot.data();
  var employee = Employee.fromJson(data!);
  return employee;
}

Future<Employee?> getProfileByDeviceId(String deviceID) async {
  var docSnapshot = await users
      .where('deviceID', isEqualTo: deviceID)
      .get()
      .then((snapshot) => snapshot.docs);
  var employee;
  if (docSnapshot.isNotEmpty) {
    employee = Employee.fromJson(docSnapshot[0].data());
  }
  return employee;
}

updateProfilebyUid(Employee employee) async {
  await users
      .doc(employee.uid)
      .update(employee.toJson())
      .then((value) => print("Employee updated"))
      .onError((error, stackTrace) => null);
}

makeContacts(String deviceID, List<ContactDevices> connections) async {

  Employee? profile = await getProfileByDeviceId(deviceID);
  if (profile != null) {
    connections.forEach((connection) async {
      Employee? employee =
          await getProfileByDeviceId(connection.deviceID.toString());
      if(profile.addContact(ContactHistory(
          contact: employee!.uid, time: DateTime.now(), fcm: employee.fcm!)))
          await updateProfilebyUid(profile);
      if(employee.addContact(ContactHistory(
          contact: profile.uid, time: DateTime.now(), fcm: profile.fcm!)))
          await updateProfilebyUid(employee);
    });

    
  }
}

Stream<DocumentSnapshot<Map<String, dynamic>>> getPersonProfile(String uid) {
  var documentStream = users.doc(uid).snapshots();
  return documentStream;
}

Stream<QuerySnapshot<Map<String, dynamic>>>? getPeople() {
  var collectionStream = users.snapshots();
  return collectionStream;
}
