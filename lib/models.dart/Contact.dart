

class Contact {
  Contact({
    required this.name,
    required this.uid,
    required this.employeeId,
    required this.groupId
  });

  String name;
  String uid;
  int employeeId;
  int groupId;

  List<Contact>? contacts;

  addContact(Contact contact){
    contacts!.add(contact);
  }

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        employeeId: json["EmployeeID"],
        name: json["Name"],
        uid: json["uid"],
        groupId: json["groupID"],
  );
}