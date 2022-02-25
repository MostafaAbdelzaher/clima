import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  final String uri;

  NetworkHelper(this.uri);

  Future getData() async {
    http.Response response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      return decodedData;
    } else {
      print(" error ${response.statusCode}");
    }
  }
}
