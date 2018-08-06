import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as Http;

class FileDownloader {
  List<String> _dictionaryStack = new List<String>();

  Future<String> _getBasePath() async =>
      (await getApplicationDocumentsDirectory()).path + '/';

  Future<String> _getFullPath() async {
    String fullPath = await _getBasePath();
    for (String dirName in _dictionaryStack) {
      fullPath += dirName;
      fullPath += '/';
    }
    return fullPath;
  }

  Future<Null> download(String url, String fileName,
      [void onComplete()]) async {
    Http.Client client = new Http.Client();
    Http.Response response = await client.get(url);
    if (response.statusCode != 200) {
      throw new FileDownloadFailException(
          '下载失败了！', url, fileName, response.statusCode);
    }
    Uint8List bytes = response.bodyBytes;
    File file = new File((await _getFullPath()) + fileName);
    if (file.existsSync()) {
      file.deleteSync();
    }
    file.createSync();
    file.writeAsBytesSync(bytes);
    if (onComplete != null) onComplete();
  }

  Future<Null> cd(String dictionaryName) async {
    if(dictionaryName=='..'){
      _dictionaryStack.removeLast();
      return;
    }
    Directory directory =
        new Directory((await _getFullPath()) + dictionaryName);
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
