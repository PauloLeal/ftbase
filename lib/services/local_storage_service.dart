import 'package:localstorage/localstorage.dart';

class LocalStorageService {
  final String storageName;
  late final LocalStorage localStorage;

  LocalStorageService._privateConstructor({required this.storageName}) {
    localStorage = LocalStorage(storageName);
  }

  static final LocalStorageService global = LocalStorageService.getStorage("global");

  static LocalStorageService getStorage(String storageName) =>
      LocalStorageService._privateConstructor(storageName: storageName);

  Future<dynamic> get(String key, {String? defaultValue}) async {
    await localStorage.ready;
    return localStorage.getItem(key);
  }

  Future<void> put(String key, dynamic value) async {
    await localStorage.setItem(key, value);
  }

  Future<void> clear() async {
    await localStorage.clear();
  }
}
