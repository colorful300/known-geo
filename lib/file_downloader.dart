import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as Http;

typedef void _CallbackVoid();

class FileDownloader {
  List<String> _dictionaryStack = new List<String>();
  _CallbackVoid onDownloadComplete;

  Future<String> getBasePath() async =>
      (await getApplicationDocumentsDirectory()).path + '/';

  Future<String> getFullPath() async {
    String fullPath = await getBasePath();
    for (String dirName in _dictionaryStack) {
      fullPath += dirName;
      fullPath += '/';
    }
    return fullPath;
  }

  Future<Null> download(String url, String fileName) async {
    File file = new File((await getFullPath()) + fileName);
    if (file.existsSync()) {
      if (onDownloadComplete != null) onDownloadComplete();
      return;
    }
    file.createSync();
    Http.Client client = new Http.Client();
    Http.Response response = await client.get(url);
    if (response.statusCode != 200) {
      throw new FileDownloadFailException(
          '下载失败了！', url, fileName, response.statusCode);
    }
    Uint8List bytes = response.bodyBytes;
    file.writeAsBytesSync(bytes);
    if (onDownloadComplete != null) onDownloadComplete();
  }

  Future<Null> cd(String dictionaryName) async {
    if (dictionaryName == '..') {
      _dictionaryStack.removeLast();
      return;
    }
    Directory directory = new Directory((await getFullPath()) + dictionaryName);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    _dictionaryStack.add(dictionaryName);
  }
}

class FileDownloadFailException implements Exception {
  final message;
  final String url;
  final String fileName;
  final int statusCode;
  FileDownloadFailException(
      [this.message, this.url, this.fileName, this.statusCode]);
  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message\nurl: $url\nFile name: $fileName\nStatus code: $statusCode";
  }
}
