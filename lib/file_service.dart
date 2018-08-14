import 'dart:convert';
import 'package:http/http.dart' as Http;
import 'escape.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:isolate';

typedef void _CallbackList(List<FileServiceItem> services);
typedef void _CallbackService(FileService service);
typedef void _CallbackVoid();

/*
serviceData的属性: 
    status: (int, 例: 30)
    message: 状态(String, 例: "ok")
    usetime: 服务器获取文档使用的时间(秒)(double, 例: 0.037,)
    guid: 唯一标识(String, 例: "F5F68B34803B1B60E0430100007F0760",)
    mdidnt: 档号(String, 例: "121414",)
    title: 标题(String, 例: "塔城幅L-44-11",)
    auther: 作者(String, 例: "潘维良,单金忠,雷建华[等]",)
    organization: 研究单位(String, 例: "新疆维吾尔自治区地质调查院第五地质调查所",)
    abs: 描述(String)
    catalog: (String, 例: "12103",)
    keyword: 
    mineral: 
    deslang: 语言(String, 例: "中文",)
    formtime: 形成时间(String, 例: "2002/03/01",)
    westbl: 西边界(String, 例: "E084°00′00″",)
    eastbl: 东边界(String, 例: "E089°00′00″",)
    southbl: 南边界(String, 例: "N46°40′00″",)
    northbl: 北边界(String, 例: "N48°40′00″",)
    geoinfoname: 研究地点(String, 例: "额敏县,塔城,伊犁哈萨克自治州",)
    geocode: 地理代码(String, 例: "654000,654200,654221",)
    mapid: 
    mapname: 
    disrporgname: 服务提供单位(String, 例: "全国地质资料馆",)
    distform: 
    mednote: 
    securl: 资料等级(String, 例: "机密",)
    protect: 
    files: 文档文件(Map<String,dynamic>)

document的属性
    guid: 唯一标识(String, 例: "04F475EE5C1E3C88E05341015A0AF7CD",)
    mdidnt: 档号(String, 例: "cgdoi.n0001/d00121414.z01_0001",)
    title: 文档标题(String, 例: "塔城幅L-44-11",)
    size: 文档大小(String, 例: "4.24M",)
    pages: 文档页数(String, 例: "159",)
    isfile: 
    format: 文件格式(String, 例: "pdf",)
    datalink: 资料链接(String, 例: "http://www.ngac.org.cn/Data/Document/04F475EE5C1E3C88E05341015A0AF7CD/",)
    datadownload: 下载链接(String, 例: "http://www.ngac.org.cn/Data/File/04F475EE5C1E3C88E05341015A0AF7CD/")

*/

class FileServiceItem {
  String url;
  String title;
  FileServiceItem(this.url, this.title);
}

class FileService {
  static List<FileServiceItem> fileServiceList = new List<FileServiceItem>();
  static _CallbackVoid onInitComplete;
  static final String url =
      'http://www.ngac.org.cn/DataService/FileService.ashx';
  static final String documentUrl =
      'http://www.ngac.org.cn/Document/document_cs.aspx?mdidntId=';
  static final RegExp listRegExp = new RegExp(r'(.+?)\t(.+)');
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
  String error;

  FileService()
      : client = new Http.Client(),
        serviceData = new Map();

  static Future<Null> init() async {
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
              fileServiceList.add(new FileServiceItem(
                  documentUrl + match.group(1), match.group(2)));
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
                if (!item.title.toLowerCase().contains(keyword.toLowerCase())) {
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

  Future<Null> loadService(String serviceUrl) async {
    Http.Response response = (await client.post(serviceUrl));
    Match match = regExp.firstMatch(response.body);
    if (match == null) {
      error = '服务器数据错误';
      if (onLoadComplete != null) onLoadComplete(this);
      return;
    }
    String fileId = match.group(1);
    response = (await client.post(url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        body: 'FileId=' + fileId));
    serviceData = jsonDecode(Escape.decode(response.body).replaceAll('\t', ' '));
    if (onLoadComplete != null) onLoadComplete(this);
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
