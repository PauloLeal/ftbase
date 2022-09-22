import 'dart:io' as io;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mime/mime.dart';

class FileData {
  String? contentType;
  Map<String, String>? metadata;

  FileData({
    this.contentType,
    this.metadata,
  });
}

class FirebaseStorageService {
  FirebaseStorageService._privateConstructor();
  static final FirebaseStorageService instance = FirebaseStorageService._privateConstructor();

  firebase_storage.Reference _createRef(String path, String id) {
    return firebase_storage.FirebaseStorage.instance.ref().child(path).child(id);
  }

  // Upload file  and returns an long lived URL for the object
  Future<String> uploadFile({
    required String path,
    required String id,
    required String filePath,
    FileData? data,
  }) async {
    String ct = lookupMimeType(filePath)!;

    final metadata = firebase_storage.SettableMetadata(
      contentType: data?.contentType ?? ct,
      customMetadata: data?.metadata,
    );

    final ref = _createRef(path, id);
    await ref.putFile(io.File(filePath), metadata);

    return await ref.getDownloadURL();
  }

  // Upload data and returns an long lived URL for the object
  Future<String> uploadData({
    required String path,
    required String id,
    required Uint8List bytes,
    FileData? data,
  }) async {
    final metadata = firebase_storage.SettableMetadata(
      contentType: data?.contentType,
      customMetadata: data?.metadata,
    );

    final ref = _createRef(path, id);
    await ref.putData(bytes, metadata);

    return await ref.getDownloadURL();
  }

  // Upload file as data and returns an long lived URL for the object
  Future<String> uploadFileData({
    required String path,
    required String id,
    required String filePath,
    FileData? data,
  }) async {
    final bytes = io.File(filePath).readAsBytesSync();
    String ct = lookupMimeType(filePath)!;

    data ??= FileData();
    data.contentType ??= ct;

    return await uploadData(path: path, id: id, bytes: bytes, data: data);
  }
}
