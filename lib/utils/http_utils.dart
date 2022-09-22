part of ftbase;

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
