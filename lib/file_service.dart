import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'escape.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:isolate';

typedef void _CallbackList(List<FileServiceItem> services);
typedef void _CallbackService(FileService service);
typedef void _CallbackMap(Map documents);
typedef void _CallbackVoid();

class FileServiceItem {
  int id;
  String guid;
  String title;
  String url;
  FileServiceItem(this.id, this.guid, this.title, this.url);
}

class FileService {
  static List<FileServiceItem> fileServiceList = new List<FileServiceItem>();
  static _CallbackVoid onInitComplete;
  static final String url =
      'http://www.ngac.org.cn/DataService/FileService.ashx';
  static final RegExp listRegExp = new RegExp(r'(\d+?)\t(.+?)\t(.+?)\t(.+)');
  static final RegExp regExp = new RegExp('FileId=(\\w+?)&');
  static bool hasInit = false;
  static ReceivePort _receivePort;
  static SendPort _sendPort;
  static const _COMMAND_GET_SERVICE_LIST_FILE = 0;
  static const _COMMAND_INIT_COMPLETE = 1;
  static const _COMMAND_GET_SEND_PORT = 2;
  static const _COMMAND_GET_KEYWORDS = 3;
  Http.Client client;
  Map serviceData;
  _CallbackService onLoadComplete;

  FileService()
      : client = new Http.Client(),
        serviceData = new Map();

  static init() async {
    ReceivePort receivePort = new ReceivePort();
    Isolate.spawn(anotherIsolate, receivePort.sendPort);
    receivePort.listen((data) async {
      if (_sendPort == null) {
        _sendPort = data;
        _sendPort.send(_COMMAND_GET_SERVICE_LIST_FILE);
        _sendPort
            .send(await rootBundle.loadString('assets/txt/service_list.txt'));
      } else {
        hasInit = true;
        if (onInitComplete != null) onInitComplete();
        receivePort.close();
      }
    });
  }

  static anotherIsolate(SendPort initSendPort) async {
    _receivePort = new ReceivePort();
    _sendPort = _receivePort.sendPort;
    initSendPort.send(_sendPort);
    bool waitForData = false;
    int command;
    SendPort sendPort;
    List<String> keywords;

    _receivePort.listen((data) async {
      if (!waitForData) {
        command = data;
        switch (command) {
          case _COMMAND_GET_SERVICE_LIST_FILE:
            waitForData = true;
            break;
          case _COMMAND_GET_SEND_PORT:
            waitForData = true;
            break;
          case _COMMAND_GET_KEYWORDS:
            waitForData = true;
            break;
        }
      } else {
        switch (command) {
          case _COMMAND_GET_SERVICE_LIST_FILE:
            waitForData = false;
            listRegExp.allMatches(data).forEach((match) {
              fileServiceList.add(new FileServiceItem(int.parse(match.group(1)),
                  match.group(2), match.group(3), match.group(4)));
            });
            initSendPort.send(_COMMAND_INIT_COMPLETE);
            break;
          case _COMMAND_GET_SEND_PORT:
            waitForData = false;
            sendPort = data;
            break;
          case _COMMAND_GET_KEYWORDS:
            waitForData = false;
            keywords = data;
            List<FileServiceItem> searchedList = new List<FileServiceItem>();
            for (FileServiceItem item in fileServiceList) {
              bool flag = true;
              for (String keyword in keywords) {
                if (!item.title.contains(keyword)) {
                  flag = false;
                  break;
                }
              }
              if (flag) {
                searchedList.add(item);
              }
            }
            sendPort.send(searchedList);
            break;
        }
      }
    });
  }

  //从ServiceUrl加载Service，执行完成后serviceData将被填满数据，使用serviceData['属性']来获取该服务的某项属性数据，所有属性名见上注释
  Future<Null> loadService(String serviceUrl) async {
    Http.Response response = (await client.post(serviceUrl));
    Match match = regExp.firstMatch(response.body);
    if (match == null) {
      return;
    }
    String fileId = match.group(1);
    response = (await client.post(url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'FileId=' + fileId));
    serviceData = jsonDecode(Escape.decode(response.body));
    serviceData['files'].forEach((name, value) {});
    if (onLoadComplete != null) onLoadComplete(this);
  }

  //遍历service中的所有document，每个document有各种属性，使用document['属性']来获取该文档的各项属性，所有属性名见上注释
  void forEachDocument(_CallbackMap callback) {
    serviceData['files'].forEach((name, list) {
      for (Map doc in list) {
        callback(doc);
      }
    });
  }

  static void searchServices(List<String> keywords, _CallbackList callback) {
    ReceivePort receivePort = new ReceivePort();
    _sendPort
      ..send(_COMMAND_GET_SEND_PORT)
      ..send(receivePort.sendPort)
      ..send(_COMMAND_GET_KEYWORDS)
      ..send(keywords);
    receivePort.listen((data) {
      callback(data);
      receivePort.close();
    });
  }
}
