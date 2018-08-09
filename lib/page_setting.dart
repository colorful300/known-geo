import 'package:flutter/material.dart';
import 'setting.dart';
import 'file_downloader.dart';

class PageSetting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PageSettingState();
}

class _PageSettingState extends State<PageSetting> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('设置'),
        ),
        body: new ListView(
          children: <Widget>[
            new _MaxResolusionSetting(),
            new _ClearCacheFiles(),
            new _About(),
          ],
        ));
  }
}

class _MaxResolusionSetting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MaxResolusionSettingState();
}

class _MaxResolusionSettingState extends State<_MaxResolusionSetting> {
  final TextEditingController controllerX = new TextEditingController();
  final TextEditingController controllerY = new TextEditingController();
  final FocusNode focusNodeX = new FocusNode();
  final FocusNode focusNodeY = new FocusNode();
  final RegExp regExp = new RegExp(r'\d+');
  @override
  Widget build(BuildContext context) {
    return new ExpansionTile(
      title: new Text('预览图片最大分辨率'),
      children: <Widget>[
        new TextField(
          decoration: new InputDecoration(
              labelText: 'X轴最大像素',
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 8.0),
              hintText: Setting.settings['resolusionX'].toString()),
          controller: controllerX,
          focusNode: focusNodeX,
          keyboardType: TextInputType.number,
        ),
        new TextField(
          decoration: new InputDecoration(
              labelText: 'Y轴最大像素',
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 8.0),
              hintText: Setting.settings['resolusionY'].toString()),
          controller: controllerY,
          focusNode: focusNodeY,
          keyboardType: TextInputType.number,
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new FlatButton(
              child: new Text('更改'),
              onPressed: () {
                Match match = regExp.firstMatch(controllerX.text);
                if (match != null)
                  Setting.settings['resolusionX'] = int.parse(match.group(0));
                controllerX.clear();
                focusNodeX.unfocus();
                match = regExp.firstMatch(controllerY.text);
                if (match != null)
                  Setting.settings['resolusionY'] = int.parse(match.group(0));
                controllerY.clear();
                focusNodeY.unfocus();
                Setting.save();
                setState(() {});
              },
            ),
          ],
        )
      ],
    );
  }
}

class _ClearCacheFiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ExpansionTile(
      title: new Text('清理缓存'),
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new FlatButton(
              child: new Text('确认清理'),
              onPressed: () {
                FileDownloader deleter = new FileDownloader()
                  ..cd('cache')
                  ..cd('images');
                for (String path in Setting.downloads) {
                  deleter.delete(path);
                }
                Setting.downloads.clear();
                Setting.saveDownloads();
              },
            )
          ],
        )
      ],
    );
  }
}

class _About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ExpansionTile(
      title: new Text('关于'),
      children: <Widget>[
        new ListTile(
          title: new Text('团队'),
          subtitle: new Text('Team Known Geo App'),
        ),
        new ListTile(
          title: new Text('应用框架'),
          subtitle: new Text('Flutter: https://flutter.io/'),
        ),
        new ListTile(
          subtitle: new Text(
            '依赖项',
            style: TextStyle(color: Colors.blue),
          ),
          dense: true,
        ),
        new ListTile(
          title: new Text('Simple Permissions'),
          subtitle:
              new Text('https://github.com/Ethras/flutter_simple_permissions'),
        ),
      ],
    );
  }
}
