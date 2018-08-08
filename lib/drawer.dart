import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final Map service;
  final bool isInfor;

  @override
  createState() => new _MyDrawer(service: service, isInfor: isInfor);
  MyDrawer({
    this.service,
    this.isInfor,
  });
}

class _MyDrawer extends State < MyDrawer > {
  Map service;
  final bool isInfor;

  Widget _info() {
    return new ListView(
      children: <Widget>[
        new Text(service['auther'], textAlign: TextAlign.center,),
        new Text('\n' + '\n' + service['organization'], textAlign: TextAlign.center,),
        new Text('northbl: ${service['northbl']}', textAlign: TextAlign.center,),
        new Text('southbl: ${service['southbl']}}', textAlign: TextAlign.center,),
        new Text('eastbl: ${service['eastbl']}', textAlign: TextAlign.center,),
        new Text('westbl: ${service['westbl']}', textAlign: TextAlign.center,),
        new Text('\n' + '\n' + '\n' + service['abs'], textAlign: TextAlign.left,),
      ],
    );
  }
  
  Widget _noInfo() {
    return new Column(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(0.0, 256.0, 0.0, 16.0),
          child: new CircularProgressIndicator(),
        ),
        new Text('数据加载中'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new Container(
        padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 2.0),
        child: (isInfor)
          ? _info()
          : _noInfo()
      ),
    );
  }

  _MyDrawer({
    this.service,
    this.isInfor,
  });
}




  