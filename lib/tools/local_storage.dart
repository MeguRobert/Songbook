import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  late String fileName;

  Future<File> get _localFile async {
    final path = await _localPath;
    final fileName = this.fileName;
    return File('$path/$fileName');
  }

  Future<String> readContent(String fileName) async {
    try {
      this.fileName = fileName;
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return empty string
      return '';
    }
  }

  Future<File> writeContent(String fileName, String content) async {
    this.fileName = fileName;
    final file = await _localFile;

    // Write the file
    return file.writeAsString(content);
  }
}
