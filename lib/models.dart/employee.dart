// To parse this JSON data, do
//
//     final employee = employeeFromJson(jsonString);

import 'dart:convert';
import 'package:apicall/services/db.dart';

Employee employeeFromJson(String str) => Employee.fromJson(json.decode(str));

String employeeToJson(Employee data) => json.encode(data.toJson());

class Employee {
  Employee({
    required this.age,
    required this.employeeId,
    required this.name,
    required this.uid,
    required this.isAdmin,
    this.state,
    this.address1,
    this.address2,
    this.contactHistory,
    this.covid,
    required this.deviceId,
    required this.groupId,
    required this.iCnumber,
    this.phone,
    required this.pinCode,
    this.quarantine,
    this.fcm,
  });

  int age;
  int employeeId;
  String name;
  String uid;
  bool isAdmin;
  String? state;
  String? address1;
  String? address2;
  List<ContactHistory>? contactHistory;
  Covid? covid;
  String deviceId;
  int groupId;
  String iCnumber;
  String? phone;
  int pinCode;
  Quarantine? quarantine;
  String? fcm;

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        age: json["Age"],
        employeeId: json["EmployeeID"],
        name: json["Name"],
        uid: json["uid"],
        isAdmin: json["isAdmin"],
        state: json["State"],
        address1: json["address1"],
        address2: json["address2"],
        contactHistory: (json["contactHistory"] != null)
            ? List<ContactHistory>.from(
                json["contactHistory"].map((x) => ContactHistory.fromJson(x)))
            : null,
        covid: (json["covid"] != null) ? Covid.fromJson(json["covid"]) : null,
        deviceId: json["deviceID"],
        groupId: json["groupID"],
        iCnumber: json["iCnumber"],
        phone: json["phone"],
        pinCode: json["pinCode"],
        quarantine: (json["quarantine"] != null)
            ? Quarantine.fromJson(json["quarantine"])
            : null,
        fcm: (json["fcm"] != null) ? json["fcm"] : '',
      );

  Map<String, dynamic> toJson() => {
        "Age": age,
        "EmployeeID": employeeId,
        "Name": name,
        "uid": uid,
        "isAdmin": isAdmin,
        "State": state,
        "address1": address1,
        "address2": address2,
        "contactHistory": contactHistory != null
            ? List<dynamic>.from(contactHistory!.map((x) => x.toJson()))
            : null,
        "covid": covid != null ? covid!.toJson() : null,
        "deviceID": deviceId,
        "groupID": groupId,
        "iCnumber": iCnumber,
        "phone": phone,
        "pinCode": pinCode,
        "quarantine": quarantine != null ? quarantine!.toJson() : null,
        "fcm": fcm != null ? fcm : '',
      };

  addContact(ContactHistory contact) {
    if(this.contactHistory == null) this.contactHistory = [];
    var canAdd = true;
    this.contactHistory!.forEach((element) {
      if (element.contact == contact.contact) { // Checking if contact already exists
        if(element.time.difference(contact.time).inHours > 5 ){ //checking if the last contact is more than 5 hours 
           element.time = contact.time; // if yes update the time
        } canAdd = false; // and don't add
      }
    });
    if (canAdd) this.contactHistory!.add(contact); // add contact if there's no previous record
  }

  Future<List<Employee>> getEmployeeContacts() async {
    List<Employee> contacts = [];
    this.contactHistory!.forEach((contact) async {
      var profile = await getProfile(contact.contact);
      contacts.add(profile);
      print(contact);
    });
    return contacts;
  }

  static getPeopleList() {
    return getPeople();
  }
}

class ContactHistory {
  ContactHistory({
    required this.contact,
    required this.time,
    required this.fcm,
  });

  String contact;
  DateTime time;
  String fcm;

  factory ContactHistory.fromJson(Map<String, dynamic>? json) => ContactHistory(
        contact: json!["contact"],
        time: json["time"].toDate(),
        fcm: (json["fcm"] != null) ? json["fcm"] : '',
      );

  Map<String, dynamic> toJson() => {
        "contact": contact,
        "time": time,
        // ignore: unnecessary_null_comparison
        "fcm": fcm != null ? fcm : '',
      };
}

class Covid {
  Covid({
    this.testDate,
    this.testMethod = 'No information',
    this.testResult,
    this.testType = 'No information',
    this.vaccinaionDate,
    this.vaccinated,
  });

  DateTime? testDate;
  String? testMethod;
  bool? testResult;
  String? testType;
  DateTime? vaccinaionDate;
  bool? vaccinated;

  factory Covid.fromJson(Map<String, dynamic>? json) => Covid(
        testDate: json!["testDate"].toDate(),
        testMethod: json["testMethod"],
        testResult: json["testResult"],
        testType: json["testType"],
        vaccinaionDate: json["vaccinaionDate"].toDate(),
        vaccinated: json["vaccinated"],
      );

  Map<String, dynamic> toJson() => {
        "testDate": testDate,
        "testMethod": testMethod,
        "testResult": testResult,
        "testType": testType,
        "vaccinaionDate": vaccinaionDate,
        "vaccinated": vaccinated,
      };
}

class Quarantine {
  Quarantine({
    required this.from,
    required this.to,
    required this.location,
    this.address,
  });

  DateTime from;
  DateTime to;
  String location;
  String? address;

  factory Quarantine.fromJson(Map<String, dynamic> json) => Quarantine(
        from: json["from"].toDate(),
        to: json["to"].toDate(),
        location: json["location"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() =>
      {"from": from, "to": to, "location": location, "address": address};
}
