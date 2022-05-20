import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  static late String fileName;

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$LocalStorage.fileName');
  }

  static Future<String> readContent(String fileName) async {
    try {
      LocalStorage.fileName = fileName;
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return empty string
      return '';
    }
  }

  static Future<File> writeContent(String fileName, String content) async {
    LocalStorage.fileName = fileName;
    final file = await _localFile;

    // Write the file
    return file.writeAsString(content);
  }
}
