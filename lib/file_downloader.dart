import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as Http;

typedef void _CallbackVoid();

class FileDownloader {
  Future<Directory> baseDirectory = getApplicationDocumentsDirectory();
  List<String> _directoryStack = new List<String>();
  _CallbackVoid onDownloadComplete;
  String error;

  void switchToExternalStorage() {
    baseDirectory = getExternalStorageDirectory();
  }

  Future<String> getBasePath() async => (await baseDirectory).path + '/';

  Future<String> getFullPath() async {
    String fullPath = await getBasePath();
    for (String dirName in _directoryStack) {
      fullPath += dirName;
      fullPath += '/';
    }
    return fullPath;
  }

  Future<Null> download(String url, String fileName) async {
    try {
      File file = new File((await getFullPath()) + fileName);
      if (file.existsSync()) {
        if (onDownloadComplete != null) onDownloadComplete();
        return;
      }
      Http.Client client = new Http.Client();
      Http.Response response = await client.get(url);
      if (response.statusCode != 200) {
        error = '下载失败了！\nstatus code: ' + response.statusCode.toString();
        if (onDownloadComplete != null) onDownloadComplete();
        return;
      }
      Uint8List bytes = response.bodyBytes;
      file.createSync();
      file.writeAsBytesSync(bytes);
    } catch (e) {
      error = e.toString();
    }
    if (onDownloadComplete != null) onDownloadComplete();
  }

  Future<Null> write(String contents, String fileName) async {
    File file = new File((await getFullPath()) + fileName);
    if (!file.existsSync()) {
      file.createSync();
    }
    file.writeAsStringSync(contents);
  }

  Future<String> read(String fileName) async {
    File file = new File((await getFullPath()) + fileName);
    if (!file.existsSync()) {
      return null;
    }
    return file.readAsString();
  }

  Future<Null> delete(String fileName) async {
    File file = new File((await getFullPath()) + fileName);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  Future<Null> cd(String directoryName) async {
    if (directoryName == '..') {
      _directoryStack.removeLast();
      return;
    }
    Directory directory = new Directory((await getFullPath()) + directoryName);
    if (!directory.existsSync()) {
      directory.createSync();
    }
    _directoryStack.add(directoryName);
  }
}
