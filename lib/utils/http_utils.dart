import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpUtils {
  static Future<http.Response> getJson(String url, Map<String, String>? headers) async {
    http.Response response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    return response;
  }

  static Future<http.Response> postJson(String url, Map<String, String>? headers, String json) async {
    return _writeJson("post", url, headers, json);
  }

  static Future<http.Response> putJson(String url, Map<String, String>? headers, String json) async {
    return _writeJson("put", url, headers, json);
  }

  static Future<http.Response> _writeJson(String method, String url, Map<String, String>? headers, String json) async {
    headers ??= {};
    headers["content-type"] = "application/json";

    var f = http.post;
    if (method == "put") {
      f = http.put;
    }

    http.Response response = await f(
      Uri.parse(url),
      headers: headers,
      body: json,
    );

    return response;
  }

  String marshalJson(Object data) {
    return jsonEncode(data);
  }

  dynamic unmarshalJson(String json) {
    return jsonDecode(json);
  }
}
