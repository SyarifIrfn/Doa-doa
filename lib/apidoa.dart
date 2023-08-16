import 'dart:convert'; // Import the dart:convert package

import 'package:http/http.dart';

const String urldoa = 'https://doa-doa-api-ahmadramadhan.fly.dev/api';

class Network {
  Future<List<dynamic>> getData(List<String> urls) async {
    List<Future<Response>> responses =
        urls.map((url) => get(Uri.parse(url))).toList();

    List<Response> completedResponses = await Future.wait(responses);

    List<String> data = [];

    for (Response response in completedResponses) {
      if (response.statusCode == 200) {
        data.add(response.body);
      } else {
        print(response.statusCode);
        throw 'Error fetching data';
      }
    }

    return data;
  }
}

class Apidoa {
  Future<List<dynamic>> getdataDoa() async {
    Network network = Network();
    var datadatadoa = await network.getData([urldoa]);
    return jsonDecode(datadatadoa[0]);
  }
}
