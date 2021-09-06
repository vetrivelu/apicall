import 'dart:convert';

import 'package:apicall/parser.dart';
import 'package:http/http.dart' as http;

Future<dynamic> getApiResponse() async {
  // var host = "https://plastic-pug-72.loca.lt";
  // ignore: unnecessary_brace_in_string_interps
  var url = Uri.parse('https://pikas.techinsight.com.my/kgateway/testing.php');

  try {
    var response = await http.get(url, headers: {"Content-Type": "text/html"});

    var text = response.body.toString();

    List<ContactDevices> conatcts;
    // printWrapped(text);
    if (response.statusCode == 200) {
      var string = response.body.toString();
      int i =0;
      var json = [];
      // var strings =  string.split('/{([^}]+)}/');
      // final pattern = RegExp(r"{([^}]+)}");
      final pattern = RegExp("(?<=\\[)[^\\[\\]]*(?=\\])");
      pattern.allMatches(string).forEach((match) {
        json.addAll(jsonDecode('['+  match.group(0)! +']'));
        i++;
      });
      print("=====================================");
      print(i);
      print(json.length);
      print("=====================================");
      // json.forEach((element) {
      //   jsonData.add(jsonDecode(element.group(0)));
      // });
      return json;
    }
  } catch (error) {
    print(error);
    return error;
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
