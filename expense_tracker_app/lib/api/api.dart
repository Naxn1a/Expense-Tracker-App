import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<dynamic> makeHttpRequest(method, body, path, http) async {
  await dotenv.load(fileName: ".env");
  final baseUrl = dotenv.env['BASEURL'] ?? "http://localhost:8080}";
  final headers = <String, String>{'Content-Type': 'application/json'};
  final url = Uri.parse("$baseUrl/api/$path");
  final encodedBody = json.encode(body);

  if (http == "GET") {
    return jsonDecode((await method(url)).body);
  } else if (http == "POST" || http == "PUT") {
    return jsonDecode(
        (await method(url, headers: headers, body: encodedBody)).body);
  } else if (http == "DELETE") {
    return jsonDecode((await method(url, headers: headers)).body);
  }
  return "Error http method";
}

dynamic methodGet(path) async {
  return makeHttpRequest(http.get, {}, path, "GET");
}

dynamic methodPost(body, path) async {
  return makeHttpRequest(http.post, body, path, "POST");
}

dynamic methodPut(body, path) async {
  return makeHttpRequest(http.put, body, path, "PUT");
}

dynamic methodDelete(path) async {
  return makeHttpRequest(http.delete, {}, path, "DELETE");
}
