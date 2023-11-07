import 'dart:io';
import 'dart:typed_data';

import 'package:ftbase/ftbase.dart';
import 'package:test/test.dart';

void main() {
  test('Upload File', () async {
    var filename = '/Users/renanjunior/Documents/GitHub/ftbase/test/teste.csv';

    await HttpUtils.postFile('http://127.0.0.1:3000/config/upload',
        File(filename).readAsBytesSync(), "teste");
  });

  test('Upload multi Files', () async {
    var filename = '/Applications/doc.pdf';

    Map<String, Uint8List> files = {
      "fileName1": File(filename).readAsBytesSync(),
      "fileName2": File(filename).readAsBytesSync()
    };
    await HttpUtils.postFiles('http://127.0.0.1:3000/config/upload', files);
  });
}
