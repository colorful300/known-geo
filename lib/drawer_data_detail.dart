import 'package:flutter/material.dart';
import 'texted_widget.dart';

class DrawerDataDetail extends StatefulWidget {
  final Map<String, dynamic> data;

  @override
  createState() => new _DrawerDataDetailState(data);
  DrawerDataDetail(this.data);
}

class _DrawerDataDetailState extends State<DrawerDataDetail> {
  final Map<String, dynamic> data;
  static const Map<String, String> propertyMap = {
    'title': '标题',
    'auther': '作者',
    'organization': '研究组织',
    'deslang': '语言',
    'formtime': '形成时间',
    'geoinfoname': '研究地点',
    'westbl': '西边界',
    'eastbl': '东边界',
    'northbl': '北边界',
    'southbl': '南边界',
    'abs': '摘要',
    'guid': '唯一标识符',
    'mdidnt': '档号',
    'geocode': '地理代码',
    'disrporgname': '资料提供单位',
    'securl': '资料等级',
    'size': '文件大小',
    'pages': '篇幅',
    'format': '格式',
    'datalink': '资料链接',
    'datadownload': '资料下载地址'
  };

  _DrawerDataDetailState(this.data);

  List<Widget> details() {
    List<Widget> detailList = new List<Widget>();
    propertyMap.forEach((key, value) {
      if (data.containsKey(key) && data[key].length > 0) {
        detailList.add(new ListTile(
          title: new Text(value),
          subtitle: new Text(data[key]),
        ));
      }
    });
    return detailList;
  }

  Widget info() {
    return new ListView(children: details());
  }

  Widget waitForInfo() {
    return new CircleProgress(text: new Text('等待资料查询'));
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(child: (data != null) ? info() : waitForInfo());
  }
}
