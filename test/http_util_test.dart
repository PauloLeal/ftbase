import 'dart:io';

import 'package:ftbase/ftbase.dart';
import 'package:test/test.dart';

void main() {
  test('Upload File', () async {
    var filename = '/Users/renanjunior/Documents/GitHub/ftbase/test/teste.csv';

    await HttpUtils.postFile('http://127.0.0.1:3000/config/upload', File(filename).readAsBytesSync(), "teste");
  });
}
