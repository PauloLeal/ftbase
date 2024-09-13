import 'package:localstorage/localstorage.dart';

class LocalStorageService {
  LocalStorageService._privateConstructor() {
    initLocalStorage();
  }

  static final LocalStorageService global = LocalStorageService.getStorage();

  static LocalStorageService getStorage() => LocalStorageService._privateConstructor();

  Future<dynamic> get(String key, {String? defaultValue}) async {
    //await localStorage.ready; TODO: REVER APOST FLUTTER UPGRADE
    return localStorage.getItem(key);
  }

  Future<void> put(String key, dynamic value) async {
    localStorage.setItem(key, value);
  }

  Future<void> clear() async {
    localStorage.clear();
  }
}
