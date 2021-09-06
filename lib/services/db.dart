import 'package:apicall/models.dart/employee.dart';
import 'package:apicall/parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference<Map<String, dynamic>> users =  firestore.collection('Employees');

Future<Employee> getProfile(String uid) async{
  // ignore: invalid_return_type_for_catch_error
  var docSnapshot = await users.doc(uid).get().catchError((onError)=>print(onError.code));
  var data =  docSnapshot.data();
  var employee = Employee.fromJson(data!);
  return employee;
}

Future<Employee?> getProfileByDeviceId(String deviceID) async {
  var docSnapshot = await users.where('deviceID', isEqualTo: deviceID).get().then((snapshot) => snapshot.docs);
  var employee;
  if(docSnapshot.isNotEmpty){
    employee = Employee.fromJson(docSnapshot[0].data());
  }
  return employee;
}

updateProfilebyUid(Employee employee) async {
  // var employee = employeeController.employee;
  await users.doc(employee.uid).update(employee.toJson());
  print("Employee UDpated");
}

makeContacts(String deviceID, List<ContactDevices> connections ) async {
  var i = 0;
  Employee? profile = await getProfileByDeviceId(deviceID);

  connections.forEach((connection) async { 
    Employee? employee = await getProfileByDeviceId(connection.deviceID.toString());
    if(profile!.contactHistory == null) profile.contactHistory = [];
    // profile.contactHistory!.add(
    //   ContactHistory(contact: employee!.uid, time: DateTime.now())
    // );
    profile.addContact(ContactHistory(contact: employee!.uid, time: DateTime.now()));
    await updateProfilebyUid(profile);
  });
}


Stream<DocumentSnapshot<Map<String,dynamic>>> getPersonProfile(String uid) {
  var documentStream = users.doc(uid).snapshots();
  return documentStream;
}


Stream<QuerySnapshot<Map<String,dynamic>>>? getPeople() {
  var collectionStream = users.snapshots();
  return collectionStream;
}









