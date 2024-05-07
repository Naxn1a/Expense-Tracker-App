import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static Future<http.Response> post(
      Map<String, dynamic> body, String path) async {
    await dotenv.load(fileName: ".env");
    final baseUrl =
        dotenv.env['BASEURL'] ?? "http://localhost:${dotenv.env['PORT']}";

    final url = Uri.parse("$baseUrl/$path");
    final headers = <String, String>{'Content-Type': 'application/json'};
    final encodedBody = json.encode(body);

    final res = await http.post(url, headers: headers, body: encodedBody);
    return res;
  }
}
