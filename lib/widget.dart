
import 'package:apicall/models.dart/employee.dart';
import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {

  final List<ContactHistory> history ;
  
  const ContactTile({Key? key, required this.history}) : super(key: key);

  List<Widget> getChildren (){
    List<Widget> children = [];
    this.history.forEach((element) {
       children.add(Text(element.contact));
     });
     children.add(Text("END"));
     return children;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Colors.indigoAccent,
        child: SingleChildScrollView(child: ListView(children: getChildren(),)),
      ),
    );
  }
}