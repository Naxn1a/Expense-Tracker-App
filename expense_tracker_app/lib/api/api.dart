import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<http.Response> makeHttpRequest(method, body, path) async {
  await dotenv.load(fileName: ".env");
  final baseUrl = dotenv.env['BASEURL'] ?? "http://localhost:8080}";
  final headers = <String, String>{'Content-Type': 'application/json'};
  final url = Uri.parse("$baseUrl/api/$path");
  final encodedBody = json.encode(body);
  return method(url, headers: headers, body: encodedBody);
}

Future<http.Response> methodPost(body, path) async {
  return makeHttpRequest(http.post, body, path);
}

Future<http.Response> methodGet(token, path) async {
  await dotenv.load(fileName: ".env");
  final baseUrl = dotenv.env['BASEURL'] ?? "http://localhost:8080}";
  final url = Uri.parse("$baseUrl/api/$path/$token");
  return http.get(url);
}
