import 'package:flutter/material.dart';
import 'page_open_file.dart';
import 'page_file_service.dart';
import 'setting.dart';

class PageCollection extends StatefulWidget {
  @override
  State < StatefulWidget > createState() => new _PageCollectionState();
  PageCollection();
}

class _PageCollectionState extends State < PageCollection > {
  _PageCollectionState();

  Widget leading(String format) {
    if (format == 'jpg') {
      return new Icon(Icons.image);
    }
    if (format == 'pdf') {
      return new Icon(Icons.insert_drive_file);
    }
    return new Icon(Icons.device_unknown);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('我的收藏'),
      ),
      body: ListView.builder(
        itemCount: Setting.collections.length,
        itemBuilder: (context, index) {
          Map data = Setting.collections.values.toList()[index];
          if (data.containsKey('format')) {
            return new ListTile(
              leading: leading(data['format']),
              title: new Text(data['title']),
              subtitle: new Text('文件类型: ' + data['format']),
              onTap: () {
                Navigator.push(context,
                  new MaterialPageRoute(builder: (context) {
                    return new PageOpenFile(data);
                  }));
              },
            );
          }
          return new ListTile(
            leading: new Icon(Icons.folder),
            title: new Text(data['title']),
            onTap: () {
              Navigator.push(context,
                new MaterialPageRoute(builder: (context) {
                  return new PageFileService(null, data);
                })
              );
            },
          );
        },
      )
    );
  }
}