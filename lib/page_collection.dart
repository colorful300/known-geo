import 'package:flutter/material.dart';
import 'page_image.dart';
import 'page_file_service.dart';

class PageCollection extends StatefulWidget {
  final Map<String, Map> collections;
  @override
  State<StatefulWidget> createState() => new _PageCollectionState(collections);
  PageCollection(this.collections);
}

class _PageCollectionState extends State<PageCollection> {
  final Map<String, Map> collections;

  _PageCollectionState(this.collections);

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
          itemCount: collections.length,
          itemBuilder: (context, index) {
            Map data = collections.values.toList()[index];
            if (data.containsKey('format')) {
              return new ListTile(
                leading: leading(data['format']),
                title: new Text(data['title']),
                subtitle: new Text('文件类型: ' + data['format']),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) {
                    return new PageImage(collections, data);
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
                  return new PageFileService(collections, null, data);
                }));
              },
            );
          },
        ));
  }
}
