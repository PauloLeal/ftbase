import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpUtils {
  static Future<Map<String, dynamic>?> getJson(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
