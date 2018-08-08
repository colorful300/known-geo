import 'package:flutter/material.dart';
import 'file_service.dart';
import 'texted_widget.dart';
import 'collection_button.dart';
import 'page_open_file.dart';
import 'drawer_data_detail.dart';

class PageFileService extends StatefulWidget {
  final FileServiceItem item;
  final Map data;
  @override
  State<StatefulWidget> createState() => new _PageFileServiceState(item, data);
  PageFileService(this.item, this.data);
}

class _PageFileServiceState extends State<PageFileService> {
  final FileServiceItem item;
  Map data;
  FileService fileService = new FileService();

  @override
  void dispose() {
    fileService.onLoadComplete = null;
    super.dispose();
  }

  Widget leading(String format) {
    if (format == 'jpg') {
      return new Icon(Icons.image);
    }
    if (format == 'pdf') {
      return new Icon(Icons.insert_drive_file);
    }
    return new Icon(Icons.device_unknown);
  }

  Widget body() {
    if (data == null) {
      fileService.onLoadComplete = (service) {
        setState(() {
          data = fileService.serviceData;
        });
      };
      fileService.loadService(item.url);
      return new Center(child: new CircleProgress(text: new Text('资料查询中')));
    }
    List<Map> fileList = new List<Map>();
    data['files'].forEach((key, value) {
      for (Map file in value) {
        if (file['format'] != 'none') {
          fileList.add(file);
        }
      }
    });
    return new ListView.builder(
      itemCount: fileList.length,
      itemBuilder: (context, index) {
        Map fileData = fileList[index];
        return new ListTile(
          leading: leading(fileData['format']),
          title: new Text(fileData['title']),
          subtitle: new Text('文件类型: ' + fileData['format']),
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return new PageOpenFile(fileData);
            }));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: data != null
            ? AppBar(
                title: new Text(data['title']),
                actions: <Widget>[new CollectionButton(data)],
              )
            : AppBar(title: new Text(item.title)),
        drawer: DrawerDataDetail(data),
        body: body());
  }

  _PageFileServiceState(this.item, this.data);
}
