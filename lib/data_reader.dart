import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as Http;

abstract class DataReader {
  final String url;
  final String statusCodeName;
  final String docName;
  int statusCode; //200表示成功，300表示参数有误，500表示服务器异常

  Http.Client client;
  String responseBody;
  Map<String, String> headers;
  Map body;
  List docs;

  Future<Null> read() async {
    StringBuffer buffer = new StringBuffer();
    bool first = true;
    headers.forEach((key, value) {
      if (first) {
        first = false;
        buffer.write('?');
        buffer.write(key);
        buffer.write('=');
        buffer.write(value);
      } else {
        buffer.write('&');
        buffer.write(key);
        buffer.write('=');
        buffer.write(value);
      }
    });
    responseBody = await client.read(url + buffer.toString());
    body = json.decode(responseBody);
    statusCode = body[statusCodeName];
    docs = body[docName];
  }

  DataReader(this.url, this.statusCodeName, this.docName)
      : client = new Http.Client(),
        headers = new Map<String, String>();
}
