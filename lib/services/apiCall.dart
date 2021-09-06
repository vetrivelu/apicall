import 'dart:convert';

import 'package:http/http.dart' as http;

Future<dynamic> getApiResponse() async {

  final url = Uri.parse('https://pikas.techinsight.com.my/kgateway/testing.php');
  final pattern = RegExp("(?<=\\[)[^\\[\\]]*(?=\\])");
  try {
    var response = await http.get(url, headers: {"Content-Type": "text/html"});
    if (response.statusCode == 200) {
      var string = response.body.toString();
      var json = [];
    //-------------------------------------------------------------------------------
      pattern.allMatches(string).forEach((match) {
        json.addAll(jsonDecode('['+  match.group(0)! +']'));
      });
    //-------------------------------------------------------------------------------
      return json;
    }
  } catch (error) {
    print(error);
    return error;
  }
}

// void printWrapped(String text) {
//   final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
//   pattern.allMatches(text).forEach((match) => print(match.group(0)));
// }
