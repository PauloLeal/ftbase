part of ftbase;

class LocalStorageService {
  LocalStorageService._privateConstructor();

  static final LocalStorageService instance = LocalStorageService._privateConstructor();

  Future<String> getString(String key, String? defaultValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? defaultValue ?? "";
  }

  Future<void> putString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
